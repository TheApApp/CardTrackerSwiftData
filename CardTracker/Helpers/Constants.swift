//
//  Constants.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//


import Foundation

let cardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

enum NavBarItemChosen: Identifiable {
    case newCard
    var id: Int {
        hashValue
    }
}

let maxBytes = 2_000_000
