//
//  FavoritesRowView.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import SwiftUI

struct FavoriteRowView: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.1)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(recipe.cookingTime) min • \(recipe.calories) kcal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
