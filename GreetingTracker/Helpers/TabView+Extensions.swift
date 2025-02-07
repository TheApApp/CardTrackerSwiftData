//
//  TabView+Extensions.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/19/23.
//

import SwiftUI

/// This Extension to the @Binding  allows you to attach a closure to a SwiftUI binding, and that closure will be executed every time the value of the binding is updated
/// 
/// Usage:
/// ```
/// TabView(selection: $selectedTab.onUpdate{ model.myFunction(item: selectedTab) }) {
///
///    Text("Graphs").tabItem{Text("Graphs")}
///       .tag(1)
///    Text("Days").tabItem{Text("Days")}
///       .tag(2)
///    Text("Summary").tabItem{Text("Summary")}
///       .tag(3)
/// }
/// ```
extension Binding {
    func onUpdate(_ closure: @escaping @Sendable () -> Void) -> Binding<Value> where Value: Sendable {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                closure()
            }
        )
    }
}
