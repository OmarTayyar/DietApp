//
//  SearchViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 01.03.26.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    @Published var selectedCategories: Set<String> = []
    @Published var cookingTimeRange: ClosedRange<Double> = 0...120
    @Published var calorieRange: ClosedRange<Double> = 0...1000
    
    private let service = RecipeService()
    
    init() {
        fetchRecipes()
    }
    
    func fetchRecipes() {
        service.fetchRecipes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let recipes):
                self.recipes = recipes
            case .failure(let error):
                print("SearchViewModel fetch error: \(error.localizedDescription)")
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
