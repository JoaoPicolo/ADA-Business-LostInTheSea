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
    }
    
    func update(deltaTime: TimeInterval) {
        // Move limit - Moves 60px/second
        node.position.x -= GameManager.speed * deltaTime
        
        if node.position.x <= 0 {
            // The ground repeats every 30px
            node.position.x += 30
        }
    }
}
