//
//  Ground.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class Limit: GameNode {
    override init(node: SKSpriteNode) {
        super.init(node: node)
        node.zPosition = 10
    }
    
    func update(deltaTime: TimeInterval) {
        // Move limit - Moves 60px/second
        node.position.x -= GameManager.shared.speed * deltaTime
        
        if node.position.x <= -60 {
            // The ground repeats every 30px
            node.position.x += 80
        }
    }
}
