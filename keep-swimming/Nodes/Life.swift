//
//  Life.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import Foundation
import SpriteKit

class Life: GameNode {
    override init(node: SKSpriteNode) {
        super.init(node: node)
        
        node.userData = NSMutableDictionary()
        node.userData?.setValue("life", forKey: "category")

        setStructConfig()
    }
    
    private func setStructConfig() {
        setPhysics()
        setTexture()
        node.position.y = CGFloat.random(in: -80...100)
    }
    
    private func setPhysics() {
        let body = SKPhysicsBody(circleOfRadius: 20)
        body.isDynamic = false
        body.categoryBitMask = Masks.obstacleMask
        body.contactTestBitMask = Masks.playerMask
        body.collisionBitMask = Masks.none

        node.physicsBody = body
    }
    
    private func setTexture() {
        node.texture = SKTexture(imageNamed: "life")
    }
}


