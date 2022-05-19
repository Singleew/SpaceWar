//
//  GameOverViewController.swift
//  SpaceWar
//
//  Created by ilia nikashov on 19.05.2022.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func resetButton(_ sender: UIButton) {
        print("reset")
    }
    
    @IBAction func lidersButton(_ sender: UIButton) {
        print("lidersButton")
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        print("menu")
    }
    
    
}
