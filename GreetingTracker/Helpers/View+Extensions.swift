//
//  View+Extensions.swift
//  GreetingTracker
//
//  Created by Michael Rowe on 12/11/23.
//

import SwiftUI

extension View {
    /// This function changes our View to UIView, then calls another function
    /// to convert the newly-made UIView to a UIImage.
    @MainActor public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        // Temporarily off-screen to avoid layout issues
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        // Get the first window from the connected scenes
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            fatalError("No windows found in the application")
        }
        
        // Add the view to the window's root view controller
        window.rootViewController?.view.addSubview(controller.view)
        
        // Use the window's bounds for the size calculation
        let size = controller.sizeThatFits(in: window.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // Convert UIView to UIImage
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}


//extension View {
//    func setupNavigationDestinations(for navigationPath: Binding<NavigationPath>) -> some View {
//        self.navigationDestination(for: NavigationDestination.self) { destination in
//            switch destination {
//            case .editCard(let card):
//                EditCardView(card: Bindable(card), navigationPath: navigationPath)
//            case .detailsCard(let card):
//                CardView(
//                    cardImage: UIImage(data: card.cardFront?.cardFront ?? Data()) ?? UIImage(),
//                    cardTitle: card.eventType?.eventName ?? "",
//                    cardDate: card.cardDate
//                )
//            case .editGreetingCard(let greetingCard):
//                EditGreetingCardView(greetingCard: greetingCard)
//            case .detailsGreetingCard(let greetingCard):
//                CardView(
//                    cardImage: UIImage(data: greetingCard.cardFront ?? Data()) ?? UIImage(),
//                    cardTitle: greetingCard.cardName,
//                    cardDate: Date()
//                )
//            }
//        }
//    }
//}
