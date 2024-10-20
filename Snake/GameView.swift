import SwiftUI
import Inject

struct GameView: View {
    @ObserveInjection var inject
    
    var body: some View {
        // Your game view content here
        Text("Hello, World!")
            .enableInjection()
    }
}
