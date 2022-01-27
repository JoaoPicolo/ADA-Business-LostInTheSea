//
//  Ground.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class Ground: GameNode {
    private var jumpVelocity = CGFloat(500)
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
    }
    
    func update(deltaTime: TimeInterval) {
        // Move ground - Moves 50px/second
        node.position.x -= GameManager.speed * deltaTime
        
        if node.position.x <= 0 {
            // The ground repeats every 24px
            node.position.x += 24
        }
    }
}
