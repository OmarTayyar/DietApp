//
//  RecipeCard.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    @State private var isFavorite: Bool = false
    var onFavoriteTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            ZStack(alignment: .topTrailing) {
                
                
                ZStack {
                    AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.1)
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure:
                            Color.gray.opacity(0.2)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .aspectRatio(1.3, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                
                Button {
                    isFavorite.toggle()
                    onFavoriteTap?()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(10)
            }
            
            
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            
            HStack(spacing: 4) {
                Text("\(recipe.cookingTime) min")
                Text("•")
                Text("\(recipe.calories) kcal")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
