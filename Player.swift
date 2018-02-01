//
//  Player.swift
//  RandomGame
//
//  Created by Ben Mach on 1/26/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

import Foundation
class Player {
    var name: String
    var score: Int = 0
    var die: Die
    
    init(name:String) {
        self.name = name
        self.die = Die()
    }
    
    func rollDie() {
        die.roll()
    }
    
    
}
