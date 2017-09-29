//
//  MoveBehavior.swift
//  MonsterWars
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class MoveBehavior: GKBehavior {

    init(speed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        if speed > 0 {
            self.setWeight(0.1, for: GKGoal(toReachTargetSpeed: speed))
            self.setWeight(0.5, for: GKGoal(toSeekAgent: seek))
            self.setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        }
    }


}
