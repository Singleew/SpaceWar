//
//  GameViewController.swift
//  SpaceWar
//
//  Created by ilia nikashov on 18.05.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    
    var gameScene: GameScene!
    var pauseViewController: PauseViewController!
    var gameOverViewController: GameOverViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseViewController = storyboard?.instantiateViewController(withIdentifier: "PauseViewController") as? PauseViewController
        
        gameOverViewController = storyboard?.instantiateViewController(withIdentifier: "gameOverViewController") as? GameOverViewController
        
        pauseViewController.delegate = self
        gameOverViewController.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showPauseScreen(_ viewController: PauseViewController) {
        pauseButton.isHidden = true
        finishButton.isHidden = true
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
        
    }
    
    func showGameOverScreen(_ viewController: GameOverViewController) {
        pauseButton.isHidden = true
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
        
    }
    
    
    func hidePauseScreen(viewController: UIViewController) {
        finishButton.isHidden = false
        pauseButton.isHidden = false
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        
        viewController.view.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {
            viewController.view.alpha = 0
        }) { completed in
            viewController.view.removeFromSuperview()
        }
        
    }
    
    
    @IBAction func pause(_ sender: UIButton) {
        sender.isHidden = true
        gameScene.pauseTheGame()
        showPauseScreen(pauseViewController)
    }
    
  
    @IBAction func stop(_ sender: UIButton) {
        sender.isHidden = true
        gameScene.pauseTheGame()
        showGameOverScreen(gameOverViewController)
        gameOverViewController.scoreLabel.text = String(gameScene.score)
    }
    
    
    func soundOnOff(viewController: PauseViewController) {
        gameScene.soundIsOn = !gameScene.soundIsOn
        gameScene.soundOnOff()
    
    
}
}

extension GameViewController: PauseViewControllerDelegate {
    
    func pauseViewControllerPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(viewController: pauseViewController)
        gameScene.continueGame()
    }
    
    func soundOnOf(_ viewController: PauseViewController) {
        soundOnOff(viewController: pauseViewController)
    }
    
    
}

extension GameViewController: GameOverViewControllerDelegate {
 
    
    func gameOverViewControllerReplayButton(_ viewController: GameOverViewController) {
        hidePauseScreen(viewController: gameOverViewController)
        gameScene.score = 0
        gameScene.continueGame()
    }
    
    func gameOverViewControllerMenuButton(_viewController: GameOverViewController) {
        hidePauseScreen(viewController: gameOverViewController)
        showPauseScreen(pauseViewController)
    }
    
    
    
}
