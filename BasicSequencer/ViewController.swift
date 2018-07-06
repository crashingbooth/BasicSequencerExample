//
//  ViewController.swift
//  BasicSequencer
//
//  Created by Jeff Holtzkener on 2018-07-05.
//  Copyright © 2018 crashingbooth. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    var seq = CustomSequencer()
    
    @IBOutlet weak var flasher1: UIView!
    @IBOutlet weak var flasher2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seq.uiManipulator = self
    
    }

    @IBAction func paly(_ sender: Any) {
        seq.akSeq.play()
    }
    
    @IBAction func stop(_ sender: Any) {
        seq.akSeq.stop()
    }
    
    @IBAction func bartype1(_ sender: Any) {
       seq.akSeq.stop()
        seq.akSeq.setTime(10.0)
        
    }
    
    @IBAction func bartype2(_ sender: Any) {
         seq.template = BarTemplate(numBeats: 5, accent: 3)
    }
}

extension ViewController: UIManipulatorDelegate {
    func flashGreen() {
        DispatchQueue.main.async {
            self.flasher1.backgroundColor = .green
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.flasher1.backgroundColor = .white

            }
        }
    }
    
    func flashBlue() {
        DispatchQueue.main.async {
            self.flasher2.backgroundColor = .blue
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.flasher2.backgroundColor = .white
            }
        }
    }

    
    
}

