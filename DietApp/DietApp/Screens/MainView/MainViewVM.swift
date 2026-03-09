//
//  MainViewVM.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

import Foundation
import SwiftUI
import Combine

final class MainViewVM: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: String = RecipeCategory.all.rawValue
    
    private let service = RecipeService()
    
    var filteredRecipes: [Recipe] {
        if selectedCategory == RecipeCategory.all.rawValue {
            return recipes
        } else {
            return recipes.filter { $0.category == selectedCategory }
        }
    }
    
    func loadRecipes() {
        // Don't reload if already loaded
        guard recipes.isEmpty else { return }
        isLoading = true
        
        service.fetchRecipes { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let recipes):
                self.recipes = recipes
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
