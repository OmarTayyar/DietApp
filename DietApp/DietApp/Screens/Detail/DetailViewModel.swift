//
//  DetailViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 03.03.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    @Published var isFavorite: Bool = false
    
    private let db = Firestore.firestore()
    
    init(recipe: Recipe) {
        self.recipe = recipe
        checkIfFavorite()
    }
    
    // MARK: - Check favorite status
    func checkIfFavorite() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(recipe.id)
            .getDocument { snapshot, error in
                if snapshot?.exists == true {
                    DispatchQueue.main.async {
                        self.isFavorite = true
                    }
                }
            }
    }
    
    // MARK: - Toggle favorite
    func toggleFavorite() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let favoriteRef = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(recipe.id)
        
        if isFavorite {
            favoriteRef.delete()
            isFavorite = false
        } else {
            favoriteRef.setData([
                "id": recipe.id,
                "title": recipe.title,
                "calories": recipe.calories,
                "cookingTime": recipe.cookingTime,
                "imageUrl": recipe.imageUrl,
                "category": recipe.category,
                "ingredients": recipe.ingredients,
                "instructions": recipe.instructions
            ])
            isFavorite = true
        }
    }
}
