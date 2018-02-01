//
//  GameViewController.swift
//  RandomGame
//
//  Created by Ben Mach on 1/29/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

//Concept of Game
//war against players
//2 or more players
//each player will have their own die
//player roll die during thrie turn
//each turn will consist of players rolling the dice once
//unless there is a tie between  the two highest numbers, then they roll again
//1st player to reach 3 turns, wins the game

//whenever the game starts, tell the game how many players are invovled
//game will generate the amount of players
//label: who's turn it is && who won that turn &&
//button: to roll die
//button: appears whenever everyone is done so that game can start a new turn


import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GameRoundDelegate, GameOverViewDelegate {
    
    

    
    var playerNames: [String] = []
    var players: [Player] = []
    var currentRound: GameRound!
    var gameState: GameState = GameState.dialogState
    
    
    @IBOutlet weak var currentPlayerInGameTableView: UITableView!
    @IBOutlet weak var playersLeftInRoundTableView: UITableView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        players = []
        if playerNames.count == 0 {
            return
        }
        for i in 0...(playerNames.count-1) {
            // playerNames:[String], players: [Players], i: Int
            var player = Player(name: playerNames[i])
            players.append(player)
        }

        self.listPlayerNames()
        
        currentPlayerInGameTableView.delegate = self
        playersLeftInRoundTableView.delegate = self
        currentPlayerInGameTableView.dataSource = self
        playersLeftInRoundTableView.dataSource = self
        
        startRound()
        
//        var turn:GameRound = GameRound()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if playerNames.count < 2 {
            dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return players.count
        if tableView == currentPlayerInGameTableView {
            return players.count
        } else {
            return currentRound.playersStillInRound.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == currentPlayerInGameTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainPlayerCell", for: indexPath)
            cell.textLabel?.text = playerNames[indexPath.row] //the cell's textLabel's text equals the playerNames' object at indexPath's row
            cell.detailTextLabel?.text = "score: \(players[indexPath.row].score)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerLeftCell", for: indexPath)
            cell.textLabel?.text = currentRound.playersStillInRound[indexPath.row].name
            // if player.hasRolledThisTurn
            // if the current game round's rollStates[indexPath.row]
            if gameState == .startNewRoundState
                || gameState == .tieBreakerState
                || currentRound.rollStates[indexPath.row].hasRolled {
                 cell.detailTextLabel?.text = "Last roll: \(currentRound.playersStillInRound[indexPath.row].die.currentSide+1) "
            } else {
                cell.detailTextLabel?.text = " - "
            }
            return cell
        }
    }
    func checkWhoWon() -> Player? {
        for player in players {
            if player.score >= 3 {
                return player
            }
        }
        return nil
    }
    
    func checkForGameOver() -> Bool {
        if let winner = checkWhoWon() {
            return true
        }
        
        return false
    }
    
    func startRound() {
        currentRound = GameRound(playersStillInRound: players)
        currentRound.delegate = self
        displayPlayerTurnRoll()
        gameState = .readyToRollState
        playersLeftInRoundTableView.reloadData()
    }
    
    func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        switch gameState {
            case .dialogState:
                displayPlayerTurnRoll()
                gameState = .readyToRollState
            
            case .tieBreakerState:
                displayPlayerTurnRoll()
                gameState = .readyToRollState

            case .readyToRollState:
                let currentPlayerName = currentRound.currentPlayer.name
                let rollResult = currentRound.currentPlayerRollDie()
                instructionLabel.text = "\(currentPlayerName) rolled \(rollResult+1)"
                playersLeftInRoundTableView.reloadData()
                if( gameState != .roundShouldEndState ) {
                    gameState = .dialogState
                }

            case .roundShouldEndState:
                currentRound.runEndRoundLogic() //end the round ORRRRR continue on with tie breaker
                currentPlayerInGameTableView.reloadData()
                playersLeftInRoundTableView.reloadData()
            
            case .startNewRoundState:
                //before starting a new round, check if the game should end instead
                //before the start of every startRound, check to see if the highest score is ten
                //two options -> start the round OR end the game
                //start the round when... no players have reached the score limit
                //end the game when... a player has reached the score limit
                
                //if no player has reached the score limit
                if !checkForGameOver() {
                    //start the round
                    startRound()
                } else {
                    gameOver()
            
            }
        }
    
    }
    
    func resetGameTapped(_ gameOverViewController: GameOverViewController) {
        dismiss(animated: true) {
        
        }
    }
    
    func rematchGameTapped(_ gamOverViewController: GameOverViewController) {
        for player in players {
            player.score = 0
        }
        //reset players' score
        currentPlayerInGameTableView.reloadData()
        //startNewRound
        startRound()
    }

    
    func displayPlayerTurnRoll() {
        instructionLabel.text = "\(currentRound.currentPlayer.name) it's your turn to roll"
    }
    
    func listPlayerNames() {
        for i in 0...(players.count-1) {
            print( "Player \(i+1) is \(players[i].name)" )
        }
    }
    
    func roundHasEnded(_ gameRound: GameRound) {
        print( "someone won the round" )
        instructionLabel.text = "\(gameRound.currentPlayer.name) won this round"
        gameState = .startNewRoundState
    }
    
    func roundEnterTieBreaker(_ gameRound: GameRound) {
        print( "there was a tie" )
        instructionLabel.text = "TIEBREAKER DEATH ROUND!!!!..."
        gameState = .tieBreakerState

    }

    func roundShouldEnd(_ gameRound: GameRound) {
        gameState = .roundShouldEndState
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        print( segue.identifier )
        if segue.identifier! == "gameOverSegue" {
            var gameOverViewController:GameOverViewController = vc as! GameOverViewController
            gameOverViewController.delegate = self
            gameOverViewController.whoWon = checkWhoWon()!.name
        }
    }
    
}
