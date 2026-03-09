//
//  MainView.swift
//  DietApp
//
//  Created by Omar Yunusov on 21.02.26.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @StateObject private var viewModel = MainViewVM()
    @State private var greetingIndex = 0
    
    private var firstName: String {
        let name = Auth.auth().currentUser?.displayName ?? ""
        return name.isEmpty ? "there" : name.components(separatedBy: " ").first ?? name
    }
    
    private var greetings: [String] {
        [
            "Welcome, \(firstName)! 👋",
            "Looking for tasty dishes? 😋",
            "Create your personalised diet 👀"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Animated Greeting
                Text(greetings[greetingIndex])
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .id(greetingIndex) // forces transition to trigger
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.5), value: greetingIndex)
                    .onAppear {
                        startRotation()
                    }
                
                // MARK: - Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(RecipeCategory.allCases, id: \.self) { category in
                            Button {
                                viewModel.selectedCategory = category.rawValue
                            } label: {
                                Text(category.rawValue)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        viewModel.selectedCategory == category.rawValue
                                        ? Color.black : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        viewModel.selectedCategory == category.rawValue
                                        ? .white : .black
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Loading
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: - Recipe Grid
                let columns = [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ]
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink {
                            DetailView(recipe: recipe)
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadRecipes()
        }
    }
    
    private func startRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                greetingIndex = (greetingIndex + 1) % greetings.count
            }
        }
    }
}
