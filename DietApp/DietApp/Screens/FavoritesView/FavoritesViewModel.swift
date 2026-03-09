//
//  FavoritesViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine

final class FavoritesViewModel: ObservableObject {

    @Published var favorites: [Recipe] = []
    
    private let db = Firestore.firestore()
    
    func fetchFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(uid)
            .collection("favorites")
            .getDocuments { [weak self] snapshot, error in
                guard let self else { return }
                guard let documents = snapshot?.documents else { return }
                
                let fetched = documents.compactMap { doc -> Recipe? in
                    let data = doc.data()
                    return Recipe(
                        id: doc.documentID,
                        title:        data["title"]       as? String ?? "",
                        cookingTime:  data["cookingTime"] as? Int    ?? 0,
                        calories:     data["calories"]    as? Int    ?? 0,
                        imageUrl:     data["imageUrl"]    as? String ?? "",
                        category:     data["category"]    as? String ?? "",
                        ingredients:  data["ingredients"] as? [String] ?? [],
                        instructions: data["instructions"] as? [String] ?? []
                    )
                }
                
                DispatchQueue.main.async {
                    self.favorites = fetched
                }
            }
    }
    
    func deleteFavorite(at offsets: IndexSet) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        offsets.forEach { index in
            let recipe = favorites[index]
            db.collection("users")
                .document(uid)
                .collection("favorites")
                .document(recipe.id)
                .delete()
        }
        // Update local array immediately for responsive UI
        favorites.remove(atOffsets: offsets)
    }
}
