//
//  GameOverViewController.swift
//  SpaceWar
//
//  Created by ilia nikashov on 19.05.2022.
//

import UIKit

protocol GameOverViewControllerDelegate {
    func gameOverViewControllerReplayButton(_ viewController: GameOverViewController)
    func gameOverViewControllerMenuButton(_viewController: GameOverViewController)
    
}



class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var delegate: GameOverViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func replayButton(_ sender: UIButton) {
        
        delegate.gameOverViewControllerReplayButton(self)
    }
    
    
    @IBAction func lidersButton(_ sender: UIButton) {
        print("lidersButton")
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        delegate.gameOverViewControllerMenuButton(_viewController: self)
    }
    
    
}
