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
    var startScaleY: CGFloat
    var startScaleX: CGFloat
    
    init(node: SKSpriteNode) {
        self.node = node
        startPosition = node.position
        startScaleX = node.xScale
        startScaleY = node.yScale
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        node.zPosition = 0
        node.alpha = 1
    }
}
