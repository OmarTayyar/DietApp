//
//  MainView.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewVM()
    let categories = [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Desserts",
        "Vegan",
        "Fast Food",
        "SeaFood"
    ]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedCategory == category ?
                                Color.black : Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                viewModel.selectedCategory == category ?
                                .white : .black
                            )
                            .cornerRadius(20)
                    }
                }
            }
        }
        
        
        
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
            }
            
            let columns = [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredRecipes) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
            .padding(.horizontal, 16)
        }
        
        .navigationTitle("Welcome Omar")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadRecipes()
        }
    }
}
