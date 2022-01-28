//
//  Player.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class Player: GameNode {
    private var jumpVelocity = CGFloat(500)
    
    override init(node: SKSpriteNode) {
        super.init(node: node)
        physicsSetup()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(circleOfRadius: 12)
        body.isDynamic = false
        body.affectedByGravity = true
        
        node.physicsBody = body
    }
    
    // Start physics
    func start() {
        node.physicsBody?.isDynamic = true
        jump()
    }
    
    func jump() {
        node.physicsBody?.velocity.dy = jumpVelocity
    }
    
    func die() {
        node.yScale = startScaleY * -1
        node.removeAllActions()
    }
    
    func reset() {
        node.yScale = startScaleY
        node.physicsBody?.isDynamic = false
        node.position = startPosition
    }
}
