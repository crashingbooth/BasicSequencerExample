//
//  CustomSequencer.swift
//  BasicSequencer
//
//  Created by Jeff Holtzkener on 2018-07-05.
//  Copyright © 2018 crashingbooth. All rights reserved.
//

import Foundation
import AudioKit

enum CustomMIDIEvent: MIDINoteNumber {
    case beatType1 = 1
    case beatType2 = 2
    case beatType3 = 3
    
    case checkForRewrite = 4
}

class CustomSequencer {
    var akSeq: AKSequencer!
    var outputCallback: AKCallbackInstrument!
    var outputTrack: AKMusicTrack!
    
    var snare: AKSynthSnare!
    var kick: AKSynthKick!
    var mixer: AKMixer!
    
    weak var uiManipulator: UIManipulatorDelegate?
    var template: BarTemplate!
    var nextStart: Int = 0

    
    fileprivate func getStarted() {
        setUp()
        setUpSounds()
        writeInitialTrack()
    }
    
    init() {
        akSeq = AKSequencer()
        getStarted()
    }
    
    fileprivate func setUp() {
        outputTrack = akSeq.newTrack()!
        outputCallback = AKCallbackInstrument()
        outputTrack.setMIDIOutput(outputCallback.midiIn)
        outputCallback.callback = myCallback
        
        akSeq.setLength(AKDuration(beats: 10000))
        akSeq.rewind()
    }
    
    fileprivate func setUpSounds() {
        snare = AKSynthSnare()
        kick = AKSynthKick()
        mixer = AKMixer(snare, kick)
        AudioKit.output = mixer
        
        try? AudioKit.start()
    }
    
    fileprivate func writeInitialTrack() {
        template = BarTemplate(numBeats: 4, accent: 2)
        nextStart = template.writeBar(track: outputTrack, startBeat: nextStart)
    }
    
    func myCallback(_ status: AKMIDIStatus, _ note: MIDINoteNumber, _ vel: MIDIVelocity ) {
        guard status == .noteOn,
            let event = CustomMIDIEvent(rawValue: note) else { return }
        print(akSeq.currentPosition, event)
        switch event {
        case .beatType1:
            uiManipulator?.flashBlue()
            snare.play(noteNumber: 60, velocity: 100)
        case .beatType2:
            uiManipulator?.flashBlue()
            kick.play(noteNumber: 60, velocity: 100)
        case .beatType3:
            uiManipulator?.flashBlue()
            uiManipulator?.flashGreen()
            snare.play(noteNumber: 60, velocity: 100)
            kick.play(noteNumber: 60, velocity: 100)
        case .checkForRewrite:
            nextStart = template.writeBar(track: outputTrack, startBeat: nextStart)
        }
    }
}



protocol UIManipulatorDelegate: class {
    func flashGreen()
    func flashBlue()
}
