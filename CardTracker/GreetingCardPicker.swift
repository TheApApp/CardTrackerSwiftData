//
//  GreetingCardPicker.swift
//  CardTracker
//
//  Created by Michael Rowe on 1/1/24.
//

// NOT USING THIS
// https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views 

import SwiftData
import SwiftUI

extension GreetingCardsPickerView {
   
    @Observable
    class GreetingCardsPicker {
        var modelContext: ModelContext
        var greetingCards = [GreetingCard]()
        
        var selectedGreetingCard: GreetingCard? {
            return GreetingCard(cardName: "DO-NOT-USE", cardFront: nil, eventType: nil, cardManufacturer: "", cardURL: "")
        }
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
                
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<GreetingCard>(sortBy: [SortDescriptor(\.cardName)])
                greetingCards = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch Failed")
            }
        }
        
        // MARK: - Intent
        func choose(greetingCard: GreetingCard) {
//            model.choose(greetingCard: greetingCard)
        }
        
    }
    
}
