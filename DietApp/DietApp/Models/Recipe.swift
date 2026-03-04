//
//  Recipe.swift
//  DietApp
//
//  Created by Omar Yunusov on 25.02.26.
//

struct Recipe: Identifiable, Codable {
    let id: String
    let title: String
    let cookingTime: Int
    let calories: Int
    let imageUrl: String
    let category: String
    let ingredients: [String]
    let instructions: [String]
}
