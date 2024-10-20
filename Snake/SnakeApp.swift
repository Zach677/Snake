//
//  SnakeApp.swift
//  Snake
//
//  Created by Star on 2024/10/20.
//

import SwiftUI
import Inject

@main
struct SnakeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .enableInjection()
        }
    }
}
