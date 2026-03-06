//
//  DetailView.swift
//  DietApp
//
//  Created by Omar Yunusov on 03.03.26.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    
    init(recipe: Recipe) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(recipe: recipe))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - HEADER IMAGE
                ZStack(alignment: .topLeading) {
                    let headerHeight: CGFloat = 320
                    
                    // Force header to screen width and fixed height in all phases
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        AsyncImage(url: URL(string: viewModel.recipe.imageUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: headerHeight)
                                    .clipped()
                            case .empty:
                                // Placeholder matches final size/layout
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                                    .clipped()
                            case .failure:
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                                    .clipped()
                            @unknown default:
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                                    .clipped()
                            }
                        }
                        .transaction { tx in
                            tx.animation = nil
                        }
                    }
                    .frame(height: headerHeight)
                    
                    LinearGradient(
                        colors: [Color.black.opacity(0.5), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                }
                
                // MARK: - CARD CONTAINER
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - TITLE
                        Text(viewModel.recipe.title)
                            .font(.largeTitle.bold())
                            .padding(.top)
                        
                        // MARK: - INFO CARDS
                        HStack(spacing: 12) {
                            infoCard(icon: "clock",
                                     value: "\(viewModel.recipe.cookingTime) mins",
                                     label: "COOKING")
                            
                            infoCard(icon: "flame",
                                     value: "\(viewModel.recipe.calories) kcal",
                                     label: "CALORIES")
                            
                            infoCard(icon: "leaf",
                                     value: viewModel.recipe.category,
                                     label: "CATEGORY")
                        }
                        
                        // MARK: - INGREDIENTS
                        Text("Ingredients")
                            .font(.title2.bold())
                        
                        ForEach(viewModel.recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // MARK: - INSTRUCTIONS
                        Text("Instructions")
                            .font(.title2.bold())
                        
                        ForEach(Array(viewModel.recipe.instructions.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.red.opacity(0.2))
                                    .clipShape(Circle())
                                
                                Text(step)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
                }
                .background(Color(.systemBackground))
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - INFO CARD
    private func infoCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.red)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}


