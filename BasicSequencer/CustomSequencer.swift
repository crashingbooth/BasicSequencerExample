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
    private var akSeq: AKSequencer!
    private var outputCallback: AKCallbackInstrument!
    private var outputTrack: AKMusicTrack!
    
    weak var uiManipulator: UIManipulatorDelegate?
    var soundGenerator: SoundGenerator
    var template: BarTemplate!
    var nextStart: Int = 0

    
    init(soundGenerator: SoundGenerator) {
        self.soundGenerator = soundGenerator
        self.akSeq = AKSequencer()
        setUpTracks()
        writeInitialTrack()
    }
    
    fileprivate func setUpTracks() {
        outputTrack = akSeq.newTrack()!
        outputCallback = AKCallbackInstrument()
        outputTrack.setMIDIOutput(outputCallback.midiIn)
        outputCallback.callback = myCallback
        
        akSeq.setLength(AKDuration(beats: 10000))
        akSeq.rewind()
    }

    
    fileprivate func writeInitialTrack() {
        template = BarTemplate(numBeats: 4, accent: 2)
        nextStart = template.writeBar(track: outputTrack, startBeat: nextStart)
    }
    
    func myCallback(_ status: AKMIDIStatus, _ note: MIDINoteNumber, _ vel: MIDIVelocity ) {
        guard status == .noteOn,
            let event = CustomMIDIEvent(rawValue: note) else { return }
        print(akSeq.currentPosition.beats, event)
        switch event {
        case .beatType1:
            snareEvent()
        case .beatType2:
            kickEvent()
        case .beatType3:
            snareEvent()
            kickEvent()
        case .checkForRewrite:
            nextStart = template.writeBar(track: outputTrack, startBeat: nextStart)
        }
    }
    
    // MARK: - Events
    fileprivate func snareEvent() {
        uiManipulator?.flashBlue()
        soundGenerator.playSnare()
    }
    
    fileprivate func kickEvent() {
        uiManipulator?.flashGreen()
        soundGenerator.playKick()
    }
    
    // MARK: - Public Facing
    func play() {
        akSeq.play()
    }
    
    func stop() {
        akSeq.stop()
    }
}

