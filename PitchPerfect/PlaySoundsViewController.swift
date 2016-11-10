//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by EricTsui on 5/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    @IBOutlet weak var innerStackView4: UIStackView!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("Play Sound Button Pressed")
        
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        print("Stop Audio Button Pressed")
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAudio()
        
        // UI display adapter
        setStacksViewAxis(orientation: UIApplication.shared.statusBarOrientation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI(.notPlaying)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      
        coordinator.animate(alongsideTransition: {
            (context) -> Void in
            let currentOrientation = UIApplication.shared.statusBarOrientation
            self.setStacksViewAxis(orientation: currentOrientation)
        }, completion: nil)
        
    }
    
    //Adjust UI according to the orientation, to avoid squashed display in landscape mode
    private func setStacksViewAxis(orientation: UIInterfaceOrientation) {
        
        var outerAxisStyle, innerAxisstyle : UILayoutConstraintAxis
        
        if orientation.isPortrait{
            (outerAxisStyle, innerAxisstyle) = (.vertical, .horizontal)
        }else{
            (outerAxisStyle, innerAxisstyle) = (.horizontal, .vertical)
        }
        
        outerStackView.axis = outerAxisStyle
        let innerStacks = [innerStackView1, innerStackView2, innerStackView3, innerStackView4]
        for stack in innerStacks {
            stack!.axis = innerAxisstyle
        }
    }

}
