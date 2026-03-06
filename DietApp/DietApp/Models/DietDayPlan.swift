//
//  DietDayPlan.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

struct DietDayPlan: Identifiable {
    let id: String          // weekDay rawValue
    let day: WeekDay
    var recipes: [Recipe]

    var totalCalories: Int { recipes.reduce(0) { $0 + $1.calories } }
    var totalDishes: Int   { recipes.count }
}
