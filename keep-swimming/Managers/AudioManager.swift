//
//  AudioManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 02/02/22.
//

import AVKit

class AudioManager: NSObject {
    static let shared = AudioManager()
    
    private var currentMusicPlayer: AVAudioPlayer?
    private var currentEffectPlayer: AVAudioPlayer?
    var musicVolume: Float = 1.0 {
        didSet { currentMusicPlayer?.volume = musicVolume }
    }
    var effectsVolume: Float = 1.0
}

extension AudioManager: AudioPlayer {
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.play()
        newPlayer.numberOfLoops = -1 // Repeat forever
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func play(effect: Effect) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }
        effectPlayer.volume = effectsVolume
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}

extension AVAudioPlayer {
    public enum AudioPlayerError: Error {
        case fileNotFound
    }
    
    public convenience init(soundFile: SoundFile) throws {
        guard let url = Bundle.main.url(forResource: soundFile.filename, withExtension: soundFile.type) else { throw AudioPlayerError.fileNotFound }
        try self.init(contentsOf: url)
    }
}
