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
    
    private let db = Firestore.firestore()
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
