//
//  RecipeService.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

import FirebaseFirestore

final class RecipeService {
    
    private let db = Firestore.firestore()
    
    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        db.collection("recipes")
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                let recipes = snapshot?.documents.compactMap { doc -> Recipe? in
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
                } ?? []
                
                DispatchQueue.main.async {
                    completion(.success(recipes))
                }
            }
    }
}
