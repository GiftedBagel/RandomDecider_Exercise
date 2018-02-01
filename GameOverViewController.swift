//
//  GameOverViewController.swift
//  RandomGame
//
//  Created by Ben Mach on 1/31/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

import UIKit

protocol GameOverViewDelegate {
    func resetGameTapped(_ gameOverViewController: GameOverViewController)
    func rematchGameTapped(_ gamOverViewController: GameOverViewController)
}

class GameOverViewController: UIViewController {

    @IBOutlet weak var resetGameButton: UIButton!
    @IBOutlet weak var rematchGameButton: UIButton!
    @IBOutlet weak var whoWonLabel: UILabel!
    @IBOutlet weak var whoWonScoreLabel: UILabel!
    
    var delegate: GameOverViewDelegate?
    var whoWon: String = ""
    var whoWhonScore: Int = 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whoWonLabel.text = "\(whoWon) WON!"
        // Do any additional setup after loading the view.
//        whoWonScoreLabel.text = "With a score of \()"
    }

    @IBAction func resetGameTapped(_ sender: Any) {
        //when the rematchGameButton has been pressed, reset score.
        dismiss(animated: true) {
            self.delegate?.resetGameTapped(self)
        }
        //reset with current players
        //reset players scores
    }
    
    @IBAction func rematchGameTapped(_ sender: Any) {
        //when the resetGamButton has been pressed, start a new game.
        
        //players should be empty
        //scores should be empty
        dismiss(animated: true) {
            self.delegate?.rematchGameTapped(self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

}
