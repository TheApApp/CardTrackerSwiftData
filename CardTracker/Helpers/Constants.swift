//
//  Constants.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//


import Foundation

/// For conisistent Date formatting across all views.
let cardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

/// This is a deprecated enum and should be removed
enum NavBarItemChosen: Identifiable {
    case newCard
    var id: Int {
        hashValue
    }
}

/// This enum is used to identify which of the tab views we are on for various functions within the application.
enum ListView: Identifiable {
    case events
    case recipients
    case greetingCard
    var id: Int {
        hashValue
    }
}

/// Maximum number of bytes for image size
let maxBytes = 2_000_000
