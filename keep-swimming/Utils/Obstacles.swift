//
//  Obstacles.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import SpriteKit

struct Obstacle {
    var position: ObjectPosition
    var imageSequence: [String]
    var range: Int = 0
    var damage: CGFloat
    var contactEnabled: Bool = true
}

struct Obstacles {
    static let seaweed1 = Obstacle(position: .bottom, imageSequence: ["s1", "s2", "s3", "s1"], damage: 5)
    static let seaweed2 = Obstacle(position: .bottom, imageSequence: [], damage: 5)
    static let seaweed3 = Obstacle(position: .top, imageSequence: [], damage: 5)
    
    static let fishes = Obstacle(position: .top, imageSequence: [], damage: 10)
    static let starsea = Obstacle(position: .top, imageSequence: [], damage: 5)
    static let whale = Obstacle(position: .top, imageSequence: [], damage: 30)
    static let turtle = Obstacle(position: .top, imageSequence: [], damage: 5)
    static let jellyfish = Obstacle(position: .top, imageSequence: [], damage: 15)
}

