//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by ilia nikashov on 19.05.2022.
//

import UIKit


protocol PauseViewControllerDelegate {
    func pauseViewControllerPlayButton (_ viewController: PauseViewController)
    func soundOnOf(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    var delegate: PauseViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        delegate.pauseViewControllerPlayButton(self)
        
    }
    
    @IBAction func storeButton(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func soundOnOFF(_ sender: UISwitch) {
        
        delegate.soundOnOf(self)
    }
    
    
    
}
