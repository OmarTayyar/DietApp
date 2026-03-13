//
//  RecipeCard.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

struct RecipeCard: View {
    
    let recipe: Recipe
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            ZStack(alignment: .topTrailing) {
                
                ZStack {
                    KFImage(URL(string: recipe.imageUrl))
                        .placeholder {
                            Color.gray.opacity(0.1)
                        }
                        .resizable()
                        .scaledToFill()
                }
                .aspectRatio(1.3, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button {
                    isFavorite.toggle()
                    if isFavorite {
                        addToFavorites(recipe: recipe)
                    } else {
                        removeFromFavorites(recipe: recipe)
                    }
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
        .background(Color.green.opacity(0.06))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Private Firestore helpers
    private func favoritesRef(for recipe: Recipe) -> DocumentReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("favorites")
            .document(recipe.id)
    }
    
    private func addToFavorites(recipe: Recipe) {
        favoritesRef(for: recipe)?.setData([
            "title":        recipe.title,
            "cookingTime":  recipe.cookingTime,
            "calories":     recipe.calories,
            "imageUrl":     recipe.imageUrl,
            "category":     recipe.category,
            "ingredients":  recipe.ingredients,
            "instructions": recipe.instructions
        ])
    }
    
    private func removeFromFavorites(recipe: Recipe) {
        favoritesRef(for: recipe)?.delete()
    }
}
