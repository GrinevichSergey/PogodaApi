//
//  ParticlesView.swift
//  WeatherApp(PogodaApi)
//
//  Created by Сергей Гриневич on 03/04/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import SpriteKit

class ParticlesView: SKView {

    
    override func didMoveToSuperview() {
        let sceen = SKScene(size: self.frame.size)
        sceen.backgroundColor = UIColor.clear
        
        self.presentScene(sceen)
        
        self.allowsTransparency = true
        self.backgroundColor = UIColor.clear
        
        if let particals = SKEmitterNode(fileNamed: "MyParticleSkine.sks") {
            particals.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
            particals.particlePositionRange = CGVector(dx: self.bounds.size.width, dy: 0)
            
            sceen.addChild(particals)
        }
        
        
    }
}
