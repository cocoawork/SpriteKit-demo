//
//  CastleComponent.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/28.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class CastleComponent: GKComponent {

    var coins = 0
    var lastCoinDrop = TimeInterval(0)


    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        let perCount = 10
        let coinDropInterval = TimeInterval(0.5)
        if CACurrentMediaTime() - lastCoinDrop > coinDropInterval {
            lastCoinDrop = CACurrentMediaTime()
            coins += perCount
        }
    }

}
