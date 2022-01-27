//
//  GameNode.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class GameNode {
    var node: SKSpriteNode
    var startPosition: CGPoint
    
    init(node: SKSpriteNode) {
        self.node = node
        startPosition = node.position
    }
}
