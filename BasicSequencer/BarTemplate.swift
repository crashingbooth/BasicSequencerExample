//
//  BarTemplate.swift
//  BasicSequencer
//
//  Created by Jeff Holtzkener on 2018-07-06.
//  Copyright © 2018 crashingbooth. All rights reserved.
//

import Foundation
import AudioKit

struct BarTemplate {
    var numBeats: Int = 4
    var accent: Int = 0

    func writeBar(track: AKMusicTrack, startBeat: Int) -> Int {
        // returns next startBeat
        let dur = AKDuration(beats: 0.2)
        for i in 0 ..< numBeats {
            let pos = AKDuration(beats: Double(i + startBeat))
            if i == 0 {
                track.add(noteNumber: CustomMIDIEvent.beatType1.rawValue,
                          velocity: 1,
                          position: pos,
                          duration: dur)
            } else if i == accent {
                track.add(noteNumber: CustomMIDIEvent.beatType3.rawValue,
                         velocity: 1,
                         position: pos,
                         duration: dur)
            } else {
                track.add(noteNumber: CustomMIDIEvent.beatType2.rawValue,
                          velocity: 1,
                          position: pos,
                          duration: dur)
            }
            
        }
        
        track.add(noteNumber: CustomMIDIEvent.checkForRewrite.rawValue,
                  velocity: 1,
                  position: AKDuration(beats: Double(startBeat + numBeats - 0.25)),
                  duration: dur)
        return startBeat + numBeats
    }
    
   
}
