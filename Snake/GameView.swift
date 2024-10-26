import SwiftUI
import Inject

struct GameView: View {
    @ObserveInjection var inject
    @StateObject private var gameViewModel = GameViewModel()

    var body: some View {
        VStack {
            Text("Score: \(gameViewModel.score)")
                .font(.headline)
                .padding()
            
            GeometryReader { geometry in
                ZStack {
                    // Game board
                    ForEach(0..<gameViewModel.boardSize, id: \.self) { row in
                        ForEach(0..<gameViewModel.boardSize, id: \.self) { column in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .border(Color.gray, width: 0.5)
                                .frame(width: geometry.size.width / CGFloat(gameViewModel.boardSize),
                                       height: geometry.size.width / CGFloat(gameViewModel.boardSize))
                                .position(x: CGFloat(column) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2,
                                          y: CGFloat(row) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2)
                        }
                    }
                    
                    // Snake
                    ForEach(gameViewModel.snake, id: \.self) { position in
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width / CGFloat(gameViewModel.boardSize),
                                   height: geometry.size.width / CGFloat(gameViewModel.boardSize))
                            .position(x: CGFloat(position.x) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2,
                                      y: CGFloat(position.y) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2)
                    }
                    
                    // Food
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width / CGFloat(gameViewModel.boardSize),
                               height: geometry.size.width / CGFloat(gameViewModel.boardSize))
                        .position(x: CGFloat(gameViewModel.food.x) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2,
                                  y: CGFloat(gameViewModel.food.y) * geometry.size.width / CGFloat(gameViewModel.boardSize) + geometry.size.width / CGFloat(gameViewModel.boardSize) / 2)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    let horizontal = abs(value.translation.width) > abs(value.translation.height)
                    if horizontal {
                        if value.translation.width > 0 {
                            gameViewModel.changeDirection(.right)
                        } else {
                            gameViewModel.changeDirection(.left)
                        }
                    } else {
                        if value.translation.height > 0 {
                            gameViewModel.changeDirection(.down)
                        } else {
                            gameViewModel.changeDirection(.up)
                        }
                    }
                }))
            
            HStack {
                Button(action: {
                    gameViewModel.startGame()
                }) {
                    Text(gameViewModel.isGameRunning ? "Restart" : "Start")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    gameViewModel.endGame()
                }) {
                    Text("End Game")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!gameViewModel.isGameRunning)
            }
            .padding()
        }
        .enableInjection()
    }
}
