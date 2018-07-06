//
//  SoundGenerator.swift
//  BasicSequencer
//
//  Created by Jeff Holtzkener on 2018-07-06.
//  Copyright © 2018 crashingbooth. All rights reserved.
//

import Foundation
import AudioKit

class SoundGenerator {
    var snare: AKSynthSnare!
    var kick: AKSynthKick!
    var mixer: AKMixer!
    
    init() {
        setUpSounds()
    }
    
    fileprivate func setUpSounds() {
        snare = AKSynthSnare()
        kick = AKSynthKick()
        mixer = AKMixer(snare, kick)
        AudioKit.output = mixer
        
        try? AudioKit.start()
    }
    
    func playSnare() {
        snare.play(noteNumber: 60, velocity: 100)
    }
    
    func playKick() {
        kick.play(noteNumber: 60, velocity: 100)
    }
}
