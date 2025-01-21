//
//  iPhone.swift
//  Greet Keeper
//
//  Created by Michael Rowe on 7/5/24.
//

import SwiftUI

@MainActor
class IsIphone : ObservableObject {
    @Published var iPhone : Bool = false
    
    @MainActor
    init() {
        if UIDevice.current.userInterfaceIdiom == .phone  {  // || UIDevice.current.userInterfaceIdiom == .vision
            self.iPhone = true
        }
    }
}
