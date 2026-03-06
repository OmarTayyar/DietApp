//
//  WeekDay.swift
//  DietApp
//
//  Created by Omar Yunusov on 06.03.26.
//

enum WeekDay: String, CaseIterable, Identifiable {
    case monday    = "Monday"
    case tuesday   = "Tuesday"
    case wednesday = "Wednesday"
    case thursday  = "Thursday"
    case friday    = "Friday"
    case saturday  = "Saturday"
    case sunday    = "Sunday"

    var id: String { rawValue }
}
