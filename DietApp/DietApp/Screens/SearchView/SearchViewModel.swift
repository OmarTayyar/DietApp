//
//  SearchViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 01.03.26.
//

import SwiftUI
import FirebaseFirestore
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    @Published var selectedCategories: Set<String> = []
    @Published var cookingTimeRange: ClosedRange<Double> = 0...120
    @Published var calorieRange: ClosedRange<Double> = 0...1000
    
    private let db = Firestore.firestore()
    
    init() {
        fetchRecipes()
    }
    
    func fetchRecipes() {
        db.collection("recipes")
            .getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents else { return }
                
                self.recipes = documents.compactMap { doc in
                    let data = doc.data()
                    
                    return Recipe(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        cookingTime: data["cookingTime"] as? Int ?? 0,
                        calories: data["calories"] as? Int ?? 0,
                        imageUrl: data["imageUrl"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        ingredients: data["ingredients"] as? [String] ?? [],
                        instructions: data["instructions"] as? [String] ?? []
                    )
                }
            }
    }
    
    var filteredRecipes: [Recipe] {
        
        var result = recipes
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        if !selectedCategories.isEmpty {
            result = result.filter {
                selectedCategories.contains($0.category)
            }
        }
        
        result = result.filter {
            Double($0.cookingTime) >= cookingTimeRange.lowerBound &&
            Double($0.cookingTime) <= cookingTimeRange.upperBound
        }
        
        result = result.filter {
            Double($0.calories) >= calorieRange.lowerBound &&
            Double($0.calories) <= calorieRange.upperBound
        }
        
        return result
    }
}
