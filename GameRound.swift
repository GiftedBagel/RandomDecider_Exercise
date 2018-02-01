//
//  PlayerTurn.swift
//  RandomGame
//
//  Created by Ben Mach on 1/26/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

//    keep track of player's information throughout the game

import Foundation

//game round delegate
//delegate to GameViewController
protocol GameRoundDelegate {
    func roundHasEnded(_ gameRound: GameRound)
    func roundEnterTieBreaker(_ gameRound: GameRound)
    func roundShouldEnd(_ gameRound: GameRound)
}



/// Keep track of players' information throughout the turn. For example, in a 3 player game, each turn starts with 3 players. After all 3 roll, highest players who tie remain. Everyone else is cleared form the turn as losers. Newn rolls occur until no more highest score ties remain.
class GameRound {
    var playersStillInRound: [Player] = []  //Using an array is more efficient than manually hardcoding
    var whoseTurnIndex: Int = 0
    var rollStates: [(player:Player, hasRolled:Bool)] = []
    var roundEnded: Bool = false    //False becuase we never want the turn to end.
    
    var currentPlayer: Player { get {
        if roundEnded || whoseTurnIndex >= playersStillInRound.count {
            return playersStillInRound[0]
        }
        return playersStillInRound[whoseTurnIndex]
        } }
    
    var delegate: GameRoundDelegate?
    
    
//    players[whoseTurnIndex]
    init(playersStillInRound: [Player]) {
        self.playersStillInRound = playersStillInRound
        generateRollStates()
    }
    
    func generateRollStates() {
        rollStates = []
        for player in self.playersStillInRound {
            rollStates.append((player: player, hasRolled: false))
        }
    }
    
    func currentPlayerRollDie() -> Int {
        // options: self, self.players, self.whoseTurnIndex
        currentPlayer.rollDie()
        rollStates[whoseTurnIndex].hasRolled = true

        var rollResult = currentPlayer.die.currentSide
        runNextTurn()
        return rollResult
    }
    
    //func to determine winner or loser for each round. Call this func when all players have rolled
    func runEndRoundLogic() {
        //keep taking out players with lower number until only one is left alive
        // options self, self.players, self.whoseTurnIndex
        
        var highestRoll: Int = 0    //
        var whoIsWinning: [Player] = []     //Set as an
        for player in playersStillInRound {
            if player.die.currentSide >= highestRoll {
                highestRoll = player.die.currentSide
                whoIsWinning.append(player)
            
//                whoIsWinning = whoIsWinning.filter({ (player) -> Bool in
//                    return player.die.currentSide >= highestRoll
//                })
                //Shorthand version of ^^^
                whoIsWinning = whoIsWinning.filter( { $0.die.currentSide >= highestRoll } )
            }
        }
        
        playersStillInRound = whoIsWinning
        generateRollStates()
        
        
        //If there is only one person left.....
        if playersStillInRound.count <= 1 {
            //tally up score
            playersStillInRound[0].score += 1
            delegate?.roundHasEnded(self)
        } else { //if there is more than one person left, continue looping
            whoseTurnIndex = 0
            roundEnded = false
            delegate?.roundEnterTieBreaker(self)
        }
    }
    
    //func next player turn
    private func runNextTurn() {
        if roundEnded {
            delegate?.roundShouldEnd(self)
            return
        }
        
        whoseTurnIndex += 1
        if whoseTurnIndex >= playersStillInRound.count {
//            whoseTurnIndex = 0
//            runEndRoundLogic()
            roundEnded = true
            delegate?.roundShouldEnd(self) 
            return
        }
        //
    }
    
    
}
