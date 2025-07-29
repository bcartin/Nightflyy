//
//  View+KeyboardPublisher.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/13/25.
//

import SwiftUI
import Combine

extension View {

  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardDidShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardDidHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
