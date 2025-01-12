//
//  extension.swift
//  Greeting Tracker
//
//  Created by Michael Rowe1 on 1/12/25.
//


import XCTest
import SwiftUI
import ViewInspector
@testable import Greeting_Tracker

// Extend AsyncImageView to conform to ViewInspector's Inspectable protocol
extension AsyncImageView: Inspectable {}

final class AsyncImageViewTests: XCTestCase {

    func testViewWithValidImageData() throws {
        // Arrange
        guard let validImage = UIImage(systemName: "star"), 
              let imageData = validImage.pngData() else {
            XCTFail("Failed to create valid image data")
            return
        }
        let view = AsyncImageView(imageData: imageData)

        // Act
        let inspected = try view.inspect()

        // Assert
        XCTAssertNoThrow(try inspected.find(ViewType.Image.self))
        let imageView = try inspected.find(ViewType.Image.self)
        XCTAssertNotNil(imageView)
    }

    func testViewWithNilImageData() throws {
        // Arrange
        let view = AsyncImageView(imageData: nil)

        // Act
        let inspected = try view.inspect()

        // Assert
        XCTAssertNoThrow(try inspected.find(ViewType.ProgressView.self))
        let progressView = try inspected.find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView)
    }

    func testViewWithNonImageData() throws {
        // Arrange
        let invalidData = Data("Not an image".utf8)
        let view = AsyncImageView(imageData: invalidData)

        // Act
        let inspected = try view.inspect()

        // Assert
        XCTAssertNoThrow(try inspected.find(ViewType.ProgressView.self))
        let progressView = try inspected.find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView)
    }
}
