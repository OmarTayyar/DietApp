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

    @Published var allRecipes: [Recipe]        = []
    @Published var selectedDay: WeekDay        = .monday
    @Published var selectedRecipeIds: [WeekDay: Set<String>] = {
        var dict: [WeekDay: Set<String>] = [:]
        WeekDay.allCases.forEach { dict[$0] = [] }
        return dict
    }()
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool  = false
    @Published var errorMessage: String?
    @Published var showAddSheet: Bool = false

    var dietDayPlans: [DietDayPlan] {
        WeekDay.allCases.compactMap { day in
            let ids = selectedRecipeIds[day] ?? []
            guard !ids.isEmpty else { return nil }
            let recipes = allRecipes.filter { ids.contains($0.id) }
            return DietDayPlan(id: day.rawValue, day: day, recipes: recipes)
        }
    }

    var hasDietPlan: Bool { !dietDayPlans.isEmpty }
    private let db = Firestore.firestore()
    
    
    func fetchRecipes() {
        isLoading = true
        db.collection("recipes").getDocuments { [weak self] snapshot, error in
            guard let self else { return }
            self.isLoading = false
            if let error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.allRecipes = snapshot?.documents.compactMap { doc -> Recipe? in
                let data = doc.data()
                return Recipe(
                    id: doc.documentID,
                    title:       data["title"]       as? String ?? "",
                    cookingTime: data["cookingTime"] as? Int    ?? 0,
                    calories:    data["calories"]    as? Int    ?? 0,
                    imageUrl:    data["imageUrl"]    as? String ?? "",
                    category:    data["category"]    as? String ?? "",
                    ingredients: (data["ingredients"] as? [Any])?.compactMap { $0 as? String } ?? [],
                    instructions:(data["instructions"] as? [Any])?.compactMap { $0 as? String } ?? []
                )
            } ?? []
        }
    }
    
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

    var currentSelectionCount: Int {
        selectedRecipeIds.values.reduce(0) { $0 + $1.count }
    }

    var currentSelectionCalories: Int {
        let allIds = selectedRecipeIds.values.flatMap { $0 }
        return allIds.reduce(0) { total, id in
            total + (allRecipes.first(where: { $0.id == id })?.calories ?? 0)
        }
    }

    func resetPlan() {
        WeekDay.allCases.forEach { selectedRecipeIds[$0] = [] }
    }
}
