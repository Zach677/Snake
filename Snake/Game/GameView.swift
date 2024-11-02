import ColorfulX
import Inject
import SwiftUI

struct GameView: View {
  @ObserveInjection var inject
  @EnvironmentObject private var gameViewModel: GameViewModel
  @State private var colors: [Color] = ColorfulPreset.winter.colors.map { Color($0) }

  var body: some View {
    ZStack {
      ColorfulView(color: $colors)
        .opacity(0.25)
        .ignoresSafeArea()

      VStack(spacing: 20) {
        scoreBoard
        gameBoard
        controlButtons
      }
      .padding()
    }
    .enableInjection()
  }

  private var scoreBoard: some View {
    HStack {
      Text("Score: \(gameViewModel.score)")
        .font(.title2)
        .fontWeight(.bold)
      Spacer()
      Text("High Score: \(gameViewModel.highScore)")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
    }
    .padding(.horizontal)
  }

  private var gameBoard: some View {
    GeometryReader { geometry in
      ZStack {
        gameBoardGrid(in: geometry)
        snakeView(in: geometry)
        foodView(in: geometry)
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .background(Color.gray.opacity(0.05))
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
    )
    .gesture(
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onEnded(handleSwipe)
    )
  }

  private func gameBoardGrid(in geometry: GeometryProxy) -> some View {
    ForEach(0..<gameViewModel.boardSize, id: \.self) { row in
      ForEach(0..<gameViewModel.boardSize, id: \.self) { column in
        Rectangle()
          .fill(Color.gray.opacity(0.1))
          .border(Color.gray.opacity(0.2), width: 0.5)
          .frame(width: cellSize(in: geometry), height: cellSize(in: geometry))
          .position(cellPosition(row: row, column: column, in: geometry))
      }
    }
  }

  private func snakeView(in geometry: GeometryProxy) -> some View {
    ForEach(gameViewModel.snake, id: \.self) { position in
      RoundedRectangle(cornerRadius: 4)
        .fill(Color.green)
        .frame(width: cellSize(in: geometry) * 0.9, height: cellSize(in: geometry) * 0.9)
        .position(cellPosition(row: position.y, column: position.x, in: geometry))
    }
  }

  private func foodView(in geometry: GeometryProxy) -> some View {
    Circle()
      .fill(Color.red)
      .frame(width: cellSize(in: geometry) * 0.8, height: cellSize(in: geometry) * 0.8)
      .position(cellPosition(row: gameViewModel.food.y, column: gameViewModel.food.x, in: geometry))
  }

  private var controlButtons: some View {
    HStack(spacing: 20) {
      Button(action: gameViewModel.startGame) {
        Text(gameViewModel.isGameRunning ? "Restart" : "Start")
          .font(.headline)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }

      Button(action: gameViewModel.endGame) {
        Text("End Game")
          .font(.headline)
          .padding()
          .frame(maxWidth: .infinity)
          .background(gameViewModel.isGameRunning ? Color.red : Color.gray)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .disabled(!gameViewModel.isGameRunning)
    }
  }

  private func cellSize(in geometry: GeometryProxy) -> CGFloat {
    geometry.size.width / CGFloat(gameViewModel.boardSize)
  }

  private func cellPosition(row: Int, column: Int, in geometry: GeometryProxy) -> CGPoint {
    let size = cellSize(in: geometry)
    return CGPoint(
      x: CGFloat(column) * size + size / 2,
      y: CGFloat(row) * size + size / 2
    )
  }

  private func handleSwipe(_ value: DragGesture.Value) {
    let horizontal = abs(value.translation.width) > abs(value.translation.height)
    if horizontal {
      gameViewModel.changeDirection(value.translation.width > 0 ? .right : .left)
    } else {
      gameViewModel.changeDirection(value.translation.height > 0 ? .down : .up)
    }
  }
}
