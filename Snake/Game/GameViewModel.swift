//
//  GameViewModel.swift
//  Snake
//
//  Created by Star on 2024/10/20.
//

import Combine
import SwiftUI

class GameViewModel: ObservableObject {
  @Published var snake: [Position] = []
  @Published var food: Position = .zero
  @Published var direction: Direction = .right
  @Published var score: Int = 0
  @Published var isGameRunning: Bool = false
  @Published var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")

  let boardSize = 20
  private var timer: AnyCancellable?

  init() {
    resetGame()
  }

  func startGame() {
    resetGame()
    isGameRunning = true
    timer = Timer.publish(every: 0.2, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.updateGame()
      }
  }

  func resetGame() {
    snake = [Position(x: 5, y: 5)]
    direction = .right
    score = 0
    isGameRunning = false
    timer?.cancel()
    generateFood()
  }

  func changeDirection(_ newDirection: Direction) {
    if !newDirection.isOpposite(to: direction) {
      direction = newDirection
    }
  }

  private func updateGame() {
    guard isGameRunning else { return }

    let newHead = nextPosition(for: snake.first!)

    if newHead == food {
      snake.insert(newHead, at: 0)
      updateScore()
      generateFood()
    } else {
      snake.insert(newHead, at: 0)
      snake.removeLast()
    }

    if isCollision(position: newHead) {
      endGame()
    }
  }

  private func nextPosition(for position: Position) -> Position {
    var newPosition = position
    switch direction {
    case .up:
      newPosition.y -= 1
    case .down:
      newPosition.y += 1
    case .left:
      newPosition.x -= 1
    case .right:
      newPosition.x += 1
    }
    return newPosition
  }

  private func generateFood() {
    var newFood: Position
    repeat {
      newFood = Position(
        x: Int.random(in: 0..<boardSize),
        y: Int.random(in: 0..<boardSize))
    } while snake.contains(newFood)
    food = newFood
  }

  private func isCollision(position: Position) -> Bool {
    return snake.dropFirst().contains(position) || 
           position.x < 0 || position.x >= boardSize || 
           position.y < 0 || position.y >= boardSize
  }

  private func updateScore() {
    score += 1
    if score > highScore {
      highScore = score
      UserDefaults.standard.set(highScore, forKey: "HighScore")
    }
  }

  func endGame() {
    isGameRunning = false
    timer?.cancel()
    // 重置分数，但保留最高分
    score = 0
  }
}

struct Position: Hashable {
  var x: Int
  var y: Int

  static let zero = Position(x: 0, y: 0)
}

enum Direction {
  case up, down, left, right

  func isOpposite(to other: Direction) -> Bool {
    switch (self, other) {
    case (.up, .down), (.down, .up), (.left, .right), (.right, .left):
      return true
    default:
      return false
    }
  }
}
