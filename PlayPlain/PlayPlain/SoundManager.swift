//
//  SoundManager.swift
//  PlayPlain
//
//  Created by cocoawork on 2017/9/29.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

import UIKit
import SpriteKit


class SoundManager {

    public static let shareInstance = SoundManager()

    let backgroundMusic = SKAction.repeatForever(SKAction.playSoundFileNamed("bg.mp3", waitForCompletion: true))
    let hitMusic = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)

}
