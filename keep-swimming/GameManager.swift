//
//  GameManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class GameManager {
    static var speed = CGFloat(100)
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
