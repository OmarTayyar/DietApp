//
//  FavoritesViewModel.swift
//  DietApp
//
//  Created by Omar Yunusov on 27.02.26.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

final class FavoritesViewModel: ObservableObject {

    @Published var favorites: [Recipe] = []
    
    private let db = Firestore.firestore()
    
    func fetchFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(uid)
            .collection("favorites")
            .getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents else { return }
                
                self.favorites = documents.compactMap { doc in
                    let data = doc.data()
                    
                    return Recipe(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        cookingTime: data["cookingTime"] as? Int ?? 0,
                        calories: data["calories"] as? Int ?? 0,
                        imageUrl: data["imageUrl"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        ingredients: data["ingredients"] as?  [String] ?? [],
                        instructions: data["instructions"] as? [String] ?? []
                    )
                }
            }
    }
    
    func delete(_ recipe: Recipe) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(uid)
            .collection("favorites")
            .document(recipe.id)
            .delete()
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
       }
}
