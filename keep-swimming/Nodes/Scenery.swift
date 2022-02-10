//
//  Scenery.swift
//  keep-swimming
//
//  Created by Mariana Florencio on 09/02/22.
//

import Foundation
import SpriteKit

class Scenery {
    private var nodes: [SKNode]
    
    init(nodes: [SKNode]) {
        self.nodes = nodes
    }
    
    func update(deltaTime: TimeInterval) {
        for (index, node) in nodes.enumerated() {
            node.position.x -= 100 * CGFloat(index + 1) * deltaTime
            
            if node.position.x <= -406 {
                node.position.x = 406
            }
        }
    }
    
}
