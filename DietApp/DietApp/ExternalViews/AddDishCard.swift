//
//  AddDishCard.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

import SwiftUI

struct AddDishCard: View {

    let recipe: Recipe
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Image
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Rectangle().fill(Color(.systemGray5))
                        }
                    }
                    .frame(height: 130)
                    .clipped()
                    .cornerRadius(12)

                    // Selection circle
                    ZStack {
                        Circle()
                            .fill(isSelected ? Color.green : Color.white.opacity(0.85))
                            .frame(width: 26, height: 26)
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .stroke(Color(.systemGray3), lineWidth: 1.5)
                                .frame(width: 26, height: 26)
                        }
                    }
                    .padding(8)
                }

                // MARK: Info
                VStack(alignment: .leading, spacing: 3) {
                    Text(recipe.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

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
                .padding(.bottom, 8)
            }
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

