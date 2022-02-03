//
//  Obstacles.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import SpriteKit

struct ObstacleStruct {
    var position: ObjectPosition
    var imageSequence: [String]
    var range: Int = 0
    var damage: CGFloat
    var contactEnabled: Bool = true
}

struct Obstacles {
    static let obstaclesBottom: [ObstacleStruct] = [
        ObstacleStruct(position: .bottom, imageSequence: ["s1", "s2", "s3", "s1"], damage: 5),
        ObstacleStruct(position: .bottom, imageSequence: [], damage: 5)
    ]
    
    static let obstaclesTop: [ObstacleStruct] = [
        ObstacleStruct(position: .top, imageSequence: [], damage: 5)
    ]

    static let obstaclesMiddle: [ObstacleStruct] = [
        ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 10),
        ObstacleStruct(position: .middle, imageSequence: [], range: 5, damage: 5),
        ObstacleStruct(position: .middle, imageSequence: [], range: 5, damage: 30),
        ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 5),
        ObstacleStruct(position: .middle, imageSequence: [], range: 10, damage: 15)
    ]
}

