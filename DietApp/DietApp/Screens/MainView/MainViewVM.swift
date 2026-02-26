//
//  MainViewVM.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

import Combine
import Foundation

final class MainViewVM: ObservableObject {
    
    @Published var recipes: [Recipe] =  []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategory: String = "All"
    
    private let service = RecipeService()
    
    var filteredRecipes: [Recipe] {
        if selectedCategory == "All" {
            return recipes
        } else {
            return recipes.filter { $0.category == selectedCategory }
        }
    }
    
    func loadRecipes() {
        isLoading = true
        
        service.fetchRecipes { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
