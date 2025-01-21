//
//  Collection+Extensions.swift
//  Greeting Tracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

/// Extension to the Swift Collection protocol to safely access array elements
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
