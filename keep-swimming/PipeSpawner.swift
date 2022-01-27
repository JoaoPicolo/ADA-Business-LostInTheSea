//
//  PipeSpawner.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import Foundation
import SpriteKit

class PipeSpawner {
    private var pipesModel: SKNode
    private var parent: SKNode // Scene root node
    private var pipes = [SKNode]()
    
    // Will spawn every 3 seconds
    private let interval = TimeInterval(3)
    private var currentTime = TimeInterval(0)
    
    init(pipesModel: SKNode, parent: SKNode) {
        self.pipesModel = pipesModel
        self.parent = parent
        currentTime = interval
    }
    
    func update(deltaTime: TimeInterval) {
        currentTime += deltaTime
        
        // Interval
        if currentTime > interval {
            spawn()
            currentTime -= interval
        }
        
        // Movement
        for pipe in pipes {
            pipe.position.x -= GameManager.speed * deltaTime
        }
        
        // Only the first must be removed
        if let firstPipe = pipes.first {
            if firstPipe.position.x < -180 {
                firstPipe.removeFromParent()
                pipes.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = pipesModel.copy() as! SKNode
        new.position.y = CGFloat.random(in: -40...140)
        parent.addChild(new)
        pipes.append(new)
    }
    
    func reset() {
        for pipe in pipes {
            pipe.removeFromParent()
        }
        pipes.removeAll()
        
        currentTime = interval
    }
}
