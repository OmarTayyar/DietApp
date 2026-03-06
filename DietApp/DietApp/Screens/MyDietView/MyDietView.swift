//
//  DietView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import SwiftUI

struct MyDietView: View {

    @StateObject private var viewModel = DietPlanViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                if viewModel.hasDietPlan {
                    dietPlanContent
                } else {
                    emptyStateContent
                }
            }
            .navigationTitle("My Diet")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.hasDietPlan {
                        Button(action: { viewModel.showAddSheet = true }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.primary)
                                .frame(width: 36, height: 36)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddDishesView(viewModel: viewModel)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Empty State
    private var emptyStateContent: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundColor(Color(.systemGray3))

            Text("No diet plan")
                .font(.title2.bold())
                .foregroundColor(.primary)

            Text("Your diet plan\nwill be displayed here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { viewModel.showAddSheet = true }) {
                HStack {
                    Text("Create diet plan")
                        .font(.headline)
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 18)
                .background(Color.red)
                .clipShape(Capsule())
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(.horizontal, 40)
    }

    // MARK: - Diet Plan Content
    private var dietPlanContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: []) {
                ForEach(viewModel.dietDayPlans) { dayPlan in
                    daySection(dayPlan)
                }
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Day Section
    private func daySection(_ dayPlan: DietDayPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {

            // Day header
            HStack {
                Text(dayPlan.day.rawValue)
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                Spacer()

                Text("\(dayPlan.totalDishes) dishes  •  \(dayPlan.totalCalories) kcal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 2)

            // Horizontal scroll of recipe cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(dayPlan.recipes) { recipe in
                        NavigationLink(destination: DetailView(recipe: recipe)) {
                            DietRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
    }
}
