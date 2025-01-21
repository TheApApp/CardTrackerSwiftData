//
//  Category.swift
//  Greet Keeper
//
//  Created by Michael Rowe1 on 12/23/24.
//

import Foundation

// MARK: - Enum for Category
/// Enum to represent the category of the recipient
enum Category: String, Codable, Identifiable, CaseIterable {
    case family
    case home
    case work
    
    var id: String { self.rawValue } // Conformance to Identifiable

    static var allCategories: [Category] {
        return Category.allCases
    }
}
