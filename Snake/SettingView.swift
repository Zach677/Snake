import Inject
import SwiftUI

struct SettingView: View {
  @ObserveInjection var inject
  @AppStorage("boardSize") private var boardSize: Int = 15
  @AppStorage("gameSpeed") private var gameSpeed: Double = 0.5
  @EnvironmentObject private var gameViewModel: GameViewModel

  var body: some View {
    NavigationStack {
      List {
        Section {
          Button("@Zach") {
            UIApplication.shared.open(URL(string: "https://x.com/Zach98899")!)
          }
          Button("Buy me a coffee! ☕️") {
            UIApplication.shared.open(URL(string: "https://github.com/sponsors/Zach677/")!)
          }
          Button("Feedback & Contact") {
            UIApplication.shared.open(URL(string: "https://github.com/Zach677/Snake")!)
          }
        } header: {
          Text("About")
        } footer: {
          Text("Wish you have a great time!")
        }
        Section {
          Button("Reset High Score") {
            gameViewModel.highScore = 0
          }
          .foregroundColor(.red)
        } header: {
          Text("Danger Zone")
        } footer: {
          Text("This is will reset your high score.")
        }
      }
      .navigationTitle("Setting")
    }
    .enableInjection()
  }
}
