//
//  Obstacles.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import SpriteKit

enum MaskType {
    case round
    case rectangle
    case alpha
}

struct ObstacleStruct {
    var imageSequence: [String] = []
    var range: CGFloat = 0
    var damage: CGFloat = 0
    var scale: CGFloat = 1
    var contactEnabled: Bool = true
    var maskType: MaskType = .round
}

struct Obstacles {
    static let obstaclesBottom: [ObstacleStruct] = [
        ObstacleStruct(imageSequence:["seeweedb1", "seeweedb2","seeweedb3","seeweedb1"], damage: 10)
    ]
    
    static let obstaclesMiddle: [ObstacleStruct] = [
        ObstacleStruct(imageSequence: ["fish1", "fish2","fish1"], range: 15, damage: 20, maskType: .alpha),
        ObstacleStruct(imageSequence: ["star1", "star2","star3","star1"], range: 10, damage: 10),
        ObstacleStruct(imageSequence: ["whale1", "whale2","whale3","whale1"], range: 5, damage: 80, scale: 0.5, maskType: .alpha),
        ObstacleStruct(imageSequence: ["turtle1", "turtle2","turtle3","turtle1"], range: 15, damage: 10),
        ObstacleStruct(imageSequence: ["jelly1","jelly2","jelly3","jelly4","jelly1"], range: 10, damage: 20, maskType: .rectangle)
    ]
    
    static let obstaclesTop: [ObstacleStruct] = [
        ObstacleStruct(imageSequence: ["seeweed1", "seeweed2", "seeweed3", "seeweed1"], damage: 10),
        ObstacleStruct(imageSequence: ["seeweeda1", "seeweeda2", "seeweeda3", "seeweeda1"], damage: 10)
    ]
}

