//
//  Audio.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 02/02/22.
//

protocol AudioPlayer {
    var musicVolume: Float { get set }
    func play(music: Music)
    func pause(music: Music)
    
    var effectsVolume: Float { get set }
    func play(effect: Effect)
}

public protocol SoundFile {
    var filename: String { get }
    var type: String { get }
}

public struct Music: SoundFile {
    public var filename: String
    public var type: String
}

public struct Effect: SoundFile {
    public var filename: String
    public var type: String
}

struct Audio {
    struct MusicFiles {
        static let background = Music(filename: "rainFuse", type: "mp3")
    }
    
    struct EffectFiles {
        static let life = Effect(filename: "tum", type: "mp3")
    }
}
