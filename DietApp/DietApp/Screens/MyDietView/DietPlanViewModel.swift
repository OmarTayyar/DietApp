//
//  DietPlanViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class DietPlanViewModel: ObservableObject {

    // MARK: - Published
    @Published var allRecipes: [Recipe] = []
    @Published var selectedDay: WeekDay = .monday
    @Published var selectedRecipeIds: [WeekDay: Set<String>] = {
        var dict: [WeekDay: Set<String>] = [:]
        WeekDay.allCases.forEach { dict[$0] = [] }
        return dict
    }()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAddSheet: Bool = false

    // MARK: - Computed
    var dietDayPlans: [DietDayPlan] {
        WeekDay.allCases.compactMap { day in
            let ids = selectedRecipeIds[day] ?? []
            guard !ids.isEmpty else { return nil }
            let recipes = allRecipes.filter { ids.contains($0.id) }
            return DietDayPlan(id: day.rawValue, day: day, recipes: recipes)
        }
    }

    var hasDietPlan: Bool { !dietDayPlans.isEmpty }

    var currentSelectionCount: Int {
        selectedRecipeIds.values.reduce(0) { $0 + $1.count }
    }

    var currentSelectionCalories: Int {
        let allIds = selectedRecipeIds.values.flatMap { $0 }
        return allIds.reduce(0) { total, id in
            total + (allRecipes.first(where: { $0.id == id })?.calories ?? 0)
        }
    }

    // MARK: - Private
    private let service = RecipeService()
    private let db = Firestore.firestore()

    // MARK: - Fetch Recipes (uses shared RecipeService)
    func fetchRecipes() {
        guard allRecipes.isEmpty else { return }
        isLoading = true
        service.fetchRecipes { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let recipes):
                self.allRecipes = recipes
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Toggle selection
    func toggleRecipe(_ recipe: Recipe) {
        if selectedRecipeIds[selectedDay]?.contains(recipe.id) == true {
            selectedRecipeIds[selectedDay]?.remove(recipe.id)
        } else {
            selectedRecipeIds[selectedDay]?.insert(recipe.id)
        }
    }

    func isSelected(_ recipe: Recipe) -> Bool {
        selectedRecipeIds[selectedDay]?.contains(recipe.id) == true
    }

    // MARK: - Persist to Firestore
    func saveDietPlan() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let planRef = db.collection("users").document(uid).collection("dietPlan")
        
        for (day, ids) in selectedRecipeIds {
            planRef.document(day.rawValue).setData(["recipeIds": Array(ids)])
        }
    }

    // MARK: - Load from Firestore
    func loadDietPlan() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let planRef = db.collection("users").document(uid).collection("dietPlan")
        
        planRef.getDocuments { [weak self] snapshot, error in
            guard let self, let documents = snapshot?.documents else { return }
            
            var loaded: [WeekDay: Set<String>] = [:]
            WeekDay.allCases.forEach { loaded[$0] = [] }
            
            for doc in documents {
                if let day = WeekDay(rawValue: doc.documentID),
                   let ids = doc.data()["recipeIds"] as? [String] {
                    loaded[day] = Set(ids)
                }
            }
            
            DispatchQueue.main.async {
                self.selectedRecipeIds = loaded
            }
        }
    }

    // MARK: - Reset
    func resetPlan() {
        WeekDay.allCases.forEach { selectedRecipeIds[$0] = [] }
        saveDietPlan()
    }
}
