//
//  DietRecipeCard.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

import SwiftUI
import Kingfisher

struct DietRecipeCard: View {

    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Image
            ZStack(alignment: .topTrailing) {
                KFImage(URL(string: recipe.imageUrl))
                    .placeholder {
                        Rectangle().fill(Color(.systemGray5))
                    }
                    .resizable()
                    .scaledToFill()
                .frame(width: 160, height: 130)
                .clipped()
                .cornerRadius(14)
            }

            // Title & info
            VStack(alignment: .leading, spacing: 3) {
                Text(recipe.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .frame(width: 148, alignment: .leading)

                HStack(spacing: 4) {
                    Text("\(recipe.cookingTime) min")
                    Text("•")
                    Text("\(recipe.calories) kcal")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 6)
            .padding(.top, 6)
            .padding(.bottom, 10)
        }
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
    }
}

