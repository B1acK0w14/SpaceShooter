//
//  TitleScene.swift
//  SpaceShooter
//
//  Created by David Penagos on 23/03/20.
//  Copyright © 2020 David Penagos. All rights reserved.

import Foundation
import SpriteKit

var playButton: UIButton!
var titleGameLabel: UILabel!
var ship: SKSpriteNode!

class TitleScene: SKScene {
     
    override func didMove(to view: SKView) {
        self.backgroundColor = .offBlackColor
        setUpText()
        spawnShip()
    }
    
    func setUpText() {
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        playButton.center = CGPoint(x: (self.view?.center.x)!, y: ((self.view?.frame.size.height)! * 3) / 3.5)
        playButton.titleLabel?.font = UIFont(name: "Futura", size: 60)
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.offWhiteColor, for: .normal)
        playButton.setTitleShadowColor(.offBlackColor, for: .normal)
        playButton.addTarget(self, action: #selector(playTheGame), for: .touchUpInside)
        self.view?.addSubview(playButton)
        
        titleGameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: 300))
        titleGameLabel.center = CGPoint(x: (self.view?.center.x)!, y: 70)
        titleGameLabel.textColor = .offWhiteColor
        titleGameLabel.font = UIFont(name: "Futura", size: 60)
        titleGameLabel.textAlignment = .center
        titleGameLabel.text = "GALAXY X"
        self.view?.addSubview(titleGameLabel)
    }
    
    func spawnShip() {
        ship = SKSpriteNode(imageNamed: "SpaceShip")
        ship?.size = CGSize(width: 300, height: 300)
        ship?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(ship!)
    }
    
    //ANNOTATION: - ACTIONS
    @objc func playTheGame() {
        self.view?.presentScene(GameScene(), transition: .doorway(withDuration: 0.4))
        playButton.removeFromSuperview()
        titleGameLabel.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
}
