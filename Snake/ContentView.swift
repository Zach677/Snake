//
//  ContentView.swift
//  Snake
//
//  Created by Star on 2024/10/20.
//

import SwiftUI
import Inject

struct ContentView: View {
    @ObserveInjection var inject
    
    var body: some View {
        GameView()
            .enableInjection()
    }
}

#Preview {
    ContentView()
}
