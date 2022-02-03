//
//  LifeBar.swift
//  keep-swimming
//
//  Created by Mariana Florencio on 03/02/22.
//

import Foundation
import SpriteKit

class LifeBar {
    var lifeNode : SKSpriteNode
    init (lifeNode: SKSpriteNode) {
        
        self.lifeNode = lifeNode
    }
    
    func updateLife (life: CGFloat) {
        if life < 0 {
            return
        }
        
        let xScale = life / 100
        lifeNode.xScale = xScale
    }
}
