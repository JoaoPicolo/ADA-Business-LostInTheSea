//
//  SpawnManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 28/01/22.
//

import Foundation
import SpriteKit

struct SpawnTimes {
    var bottom = TimeInterval(5)
    var middle = TimeInterval(3)
    var top = TimeInterval(4)
    var life = TimeInterval(20)
}


enum Positions {
    case bottom
    case middle
    case top
}

struct Objects {
    struct BottomObstacle {
        static let position = CGPoint(x: 465, y: 148)
    }
    
    struct MiddleObstacle {
        static let position = CGPoint(x: 465, y: 10)
    }
    
    struct TopObstacle {
        static let position = CGPoint(x: 465, y: -148)
    }
}


class SpawnManager {
    private var parent: SKNode!
    private var spawnIntervals = SpawnTimes()
    private var lowerInterval = CGFloat(2)
    
    // Obstacles
    private var obstacles = [Obstacle]()
    private var obstaclesTimes = SpawnTimes()
    
    // Life
    private var lives = [Life]()
    private var lifeTime = TimeInterval(0)
    
    init(parent: SKNode) {
        self.parent = parent
        initTime()
    }
    
    private func initTime() {
        obstaclesTimes.bottom = TimeInterval(0)
        obstaclesTimes.middle = TimeInterval(0)
        obstaclesTimes.top = TimeInterval(0)
    }
    
    private func updateTime(deltaTime: TimeInterval) {
        // Obstacles
        obstaclesTimes.bottom += deltaTime
        obstaclesTimes.middle += deltaTime
        obstaclesTimes.top += deltaTime
        
        // Life
        lifeTime += deltaTime
    }
    
    func updateObjects(deltaTime: TimeInterval) {
        updateTime(deltaTime: deltaTime)
        verifySpawn()
        moveObstacles(deltaTime: deltaTime)
        moveLives(deltaTime: deltaTime)
    }
    
    func updateInterval(currentTime: TimeInterval, currentInterval: TimeInterval) -> (time: TimeInterval, interval: TimeInterval) {
        // Keep incrementing a value, instead of using just game speed -> Adds a value
        let newValue = ((currentInterval * GameManager.shared.initialSpeed) / GameManager.shared.speed)
        var newInterval = currentInterval
        
        if newValue >= lowerInterval {
            newInterval = CGFloat.random(in: lowerInterval...newValue)
        }
        
        let newCurrent = currentTime - newInterval
        return (newCurrent, newInterval)
    }
    
    func verifySpawn() {
        // Obstacles
        if obstaclesTimes.bottom > spawnIntervals.bottom {
            spawnObstacle(pos: Positions.bottom)
            let updatedTime = updateInterval(currentTime: obstaclesTimes.bottom, currentInterval: spawnIntervals.bottom)
            obstaclesTimes.bottom = updatedTime.time
            spawnIntervals.bottom = updatedTime.interval
        }
        if obstaclesTimes.middle > spawnIntervals.middle {
            spawnObstacle(pos: Positions.middle)
            let updatedTime = updateInterval(currentTime: obstaclesTimes.middle, currentInterval: spawnIntervals.middle)
            obstaclesTimes.middle = updatedTime.time
            spawnIntervals.middle = updatedTime.interval
        }
        if obstaclesTimes.top > spawnIntervals.top {
            spawnObstacle(pos: Positions.top)
            let updatedTime = updateInterval(currentTime: obstaclesTimes.top, currentInterval: spawnIntervals.top)
            obstaclesTimes.top = updatedTime.time
            spawnIntervals.top = updatedTime.interval
        }
        
        // Lives
        if lifeTime > spawnIntervals.life {
            spawnLife()
            lifeTime -= spawnIntervals.life
        }
    }
    
    func spawnObstacle(pos: Positions) {
        let newObstacle: ObstacleStruct
        let newNode = SKSpriteNode()
        
        switch pos {
        case .bottom:
            newObstacle = Obstacles.obstaclesBottom.randomElement()!
            newNode.position = Objects.BottomObstacle.position
        case .middle:
            newObstacle = Obstacles.obstaclesMiddle.randomElement()!
            newNode.position = Objects.MiddleObstacle.position
        case .top:
            newObstacle = Obstacles.obstaclesTop.randomElement()!
            newNode.position = Objects.TopObstacle.position
        }
        
        // Adds node and mounts obstacle
        let obstacle = Obstacle(node: newNode, obstacleStruct: newObstacle, position: pos)
        obstacles.append(obstacle)
        parent.addChild(newNode)
    }
    
    func spawnLife() {
        let newNode = SKSpriteNode()
        newNode.position = Objects.MiddleObstacle.position
        
        let life = Life(node: newNode)
        lives.append(life)
        parent.addChild(newNode)
    }
    
    private func moveObstacles(deltaTime: TimeInterval) {
        // Movement
        for obstacle in obstacles {
            obstacle.node.position.x -= GameManager.shared.speed * deltaTime
        }
        
        // Only the first must be removed
        if let first = obstacles.first {
            if first.node.position.x < -500 {
                first.node.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    private func moveLives(deltaTime: TimeInterval) {
        // Movement
        for life in lives {
            life.node.position.x -= GameManager.shared.speed * deltaTime
        }
        
        // Only the first must be removed
        if let first = lives.first {
            if first.node.position.x < -500 {
                first.node.removeFromParent()
                lives.removeFirst()
            }
        }
    }
    
    func getDamage(node: SKNode) -> CGFloat {
        for obstacle in obstacles {
            if obstacle.node == node {
                if obstacle.obstacleStruct.contactEnabled {
                    obstacle.obstacleStruct.contactEnabled = false
                    return obstacle.obstacleStruct.damage
                } else {
                    return 0
                }
            }
        }
        return 20
    }
    
    func resetSpawns() {
        // Obstacles
        for obstacle in obstacles {
            obstacle.node.removeFromParent()
        }
        obstacles.removeAll()
        
        // Lives
        for life in lives {
            life.node.removeFromParent()
        }
        lives.removeAll()
    }
}
