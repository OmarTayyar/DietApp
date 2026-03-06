//
//  AddDishesView.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

import SwiftUI

struct AddDishesView: View {

    @ObservedObject var viewModel: DietPlanViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header
            headerBar

            // MARK: Day Selector
            daySelector

            // MARK: Recipe Grid
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                recipeGrid
            }

            // MARK: Bottom CTA
            if viewModel.currentSelectionCount > 0 {
                bottomBar
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { viewModel.fetchRecipes() }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Text("Add Dishes")
                .font(.title2.bold())

            Spacer()

            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 38, height: 38)
                    .overlay(Image(systemName: "magnifyingglass").foregroundColor(.primary))

                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 38, height: 38)
                    .overlay(Image(systemName: "line.3.horizontal.decrease").foregroundColor(.primary))

                Button(action: { dismiss() }) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 38, height: 38)
                        .overlay(Image(systemName: "xmark").foregroundColor(.primary))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }

    // MARK: - Day Selector (horizontal scroll)
    private var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WeekDay.allCases) { day in
                    let isSelected = viewModel.selectedDay == day
                    let count = viewModel.selectedRecipeIds[day]?.count ?? 0

                    Button(action: { viewModel.selectedDay = day }) {
                        HStack(spacing: 4) {
                            Text(day.rawValue)
                                .font(.subheadline.weight(isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? .white : .primary)

                            if count > 0 {
                                Text("\(count)")
                                    .font(.caption2.bold())
                                    .foregroundColor(isSelected ? Color.green : .white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(isSelected ? Color.white : Color.green)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(isSelected ? Color.green : Color(.systemGray5))
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Recipe Grid
    private var recipeGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(viewModel.allRecipes) { recipe in
                    AddDishCard(recipe: recipe, isSelected: viewModel.isSelected(recipe)) {
                        viewModel.toggleRecipe(recipe)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, viewModel.currentSelectionCount > 0 ? 100 : 24)
        }
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 6) {
                    Text("\(viewModel.currentSelectionCount) dishes")
                        .font(.headline)
                    Text("•")
                    Text("\(viewModel.currentSelectionCalories) kcal")
                        .font(.headline)
                    Image(systemName: "plus")
                        .font(.headline.bold())
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.green)
                .clipShape(Capsule())
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
        }
        .padding(.top, 8)
        .background(
            LinearGradient(
                colors: [Color(.systemGroupedBackground).opacity(0), Color(.systemGroupedBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
