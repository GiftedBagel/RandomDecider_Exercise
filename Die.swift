//
//  Die.swift
//  RandomGame
//
//  Created by Ben Mach on 1/26/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

import Foundation
class Die {
    var sides: Int = 6
//    private var currentSide: Int = 0
    
    private(set) var currentSide:Int = 0
    init() {
    }
    
    func roll(){
        currentSide = Int(arc4random_uniform(UInt32(sides)))
    }
}
