//
//  FilterSheetView.swift
//  DietApp
//
//  Created by Omar Yunusov on 01.03.26.
//

import SwiftUI

struct FilterSheetView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Snack", "Vegan", "SeaFood", "Fast Food", "Desserts"]
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Filters")
                    .font(.largeTitle.bold())
                
                // MARK: Categories
                Text("Category")
                    .font(.headline)
                
                WrapCategoriesView(
                    categories: categories,
                    selected: $viewModel.selectedCategories
                )
                
                // MARK: Cooking Time
                VStack(alignment: .leading, spacing: 10) {
                    Text("Cooking time")
                        .font(.headline)

                    Text("\(Int(viewModel.cookingTimeRange.lowerBound)) min – \(Int(viewModel.cookingTimeRange.upperBound)) min")
                        .font(.title3.bold())

                    RangeSlider(range: $viewModel.cookingTimeRange, bounds: 0...120, step: 1)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Dish calories")
                        .font(.headline)

                    Text("\(Int(viewModel.calorieRange.lowerBound)) – \(Int(viewModel.calorieRange.upperBound)) kcal")
                        .font(.title3.bold())

                    RangeSlider(range: $viewModel.calorieRange, bounds: 0...1200, step: 5)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Show \(viewModel.filteredRecipes.count) dishes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
    }
}
