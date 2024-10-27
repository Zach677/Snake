import Inject
import SwiftUI

struct MainView: View {
  @ObserveInjection var inject

  var body: some View {
    TabView {
      GameView()
        .tabItem {
          Label("Game", systemImage: "gamecontroller")
        }
      SettingView()
        .tabItem {
          Label("Setting", systemImage: "gear")
        }
    }
    .enableInjection()
  }
}
