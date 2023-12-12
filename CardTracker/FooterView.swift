//
//  FooterView.swift
//  CardTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

struct FooterView: View {
    var page: Int
    var pages: Int
    
    init(page: Int, pages: Int) {
        self.page = page
        self.pages = pages
    }
    var body: some View {
        HStack {
            Text("Page \((page).formatted()) of \(pages.formatted())")
        }
        .font(.caption)
        .padding()
        .frame(width: 612, height: 40)
    }}

#Preview {
    FooterView(page: 1, pages: 90)
}
