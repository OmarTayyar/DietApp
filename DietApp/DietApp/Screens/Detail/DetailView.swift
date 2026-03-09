//
//  DetailView.swift
//  DietApp
//
//  Created by Omar Yunusov on 03.03.26.
//

import SwiftUI

struct DetailView: View {
    
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - HEADER IMAGE
                ZStack(alignment: .topLeading) {
                    let headerHeight: CGFloat = 320
                    
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: headerHeight)
                                    .clipped()
                            case .empty:
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                            case .failure:
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                            @unknown default:
                                Color.gray.opacity(0.2)
                                    .frame(width: width, height: headerHeight)
                            }
                        }
                        .transaction { tx in tx.animation = nil }
                    }
                    .frame(height: headerHeight)
                    
                    LinearGradient(
                        colors: [Color.black.opacity(0.5), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                    
                    // MARK: - Back Button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.top, 55)
                    .padding(.leading, 16)
                }
                
                // MARK: - CARD CONTAINER
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - TITLE
                        Text(recipe.title)
                            .font(.largeTitle.bold())
                            .padding(.top)
                        
                        // MARK: - INFO CARDS
                        HStack(spacing: 12) {
                            infoCard(icon: "clock",
                                     value: "\(recipe.cookingTime) mins",
                                     label: "COOKING")
                            
                            infoCard(icon: "flame",
                                     value: "\(recipe.calories) kcal",
                                     label: "CALORIES")
                            
                            infoCard(icon: "leaf",
                                     value: recipe.category,
                                     label: "CATEGORY")
                        }
                        
                        // MARK: - INGREDIENTS
                        Text("Ingredients")
                            .font(.title2.bold())
                        
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // MARK: - INSTRUCTIONS
                        Text("Instructions")
                            .font(.title2.bold())
                        
                        ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
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
                    .padding(.horizontal, 16)
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
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
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
