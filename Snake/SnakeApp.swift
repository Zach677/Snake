//
//  SnakeApp.swift
//  Snake
//
//  Created by Star on 2024/10/20.
//

import Inject
import SwiftUI

@main
private struct SnakeApp: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      MainView()
        .enableInjection()
    }
  }
}
