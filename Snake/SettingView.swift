import Inject
import SwiftUI

struct SettingView: View {
  @ObserveInjection var inject
  @AppStorage("boardSize") private var boardSize: Int = 15
  @AppStorage("gameSpeed") private var gameSpeed: Double = 0.5

  var body: some View {
    Form {
      Section("Game Settings") {
        Stepper("Board Size: \(boardSize)x\(boardSize)", value: $boardSize, in: 10...20)

        VStack(alignment: .leading) {
          Text("Game Speed")
          Slider(value: $gameSpeed, in: 0.1...1.0) {
            Text("Game Speed")
          } minimumValueLabel: {
            Text("Fast")
          } maximumValueLabel: {
            Text("Slow")
          }
        }
      }

      Section {
        Button("Reset High Score") {
          UserDefaults.standard.removeObject(forKey: "HighScore")
        }
        .foregroundColor(.red)
      }
    }
    .navigationTitle("Settings")
    .enableInjection()
  }
}

#Preview {
  NavigationView {
    SettingView()
  }
}
