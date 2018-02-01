//
//  ViewController.swift
//  RandomGame
//
//  Created by Ben Mach on 1/26/18.
//  Copyright © 2018 Nosneb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var startScreenView: UIView!
    @IBOutlet weak var addPlayerNameTextField: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var playerNamesTableView: UITableView!
    @IBOutlet weak var clearPlayerNamesButton: UIButton!
    
    var testMode:Bool = false    //This line of code is for testing purposes only. Will remove when testing phase is done.
    
    var playerNames: [String] = []
    var firstTimeViewDidAppear: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        playerNamesTableView.delegate = self
        playerNamesTableView.dataSource = self
        
        addPlayerButton.isEnabled = false
        
        if( testMode ) {
            playerNames = ["Ben", "Derek", "Trung"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //When "AddPlayerButton" has been tapped
    @IBAction func addPlayerButtonTapped(_ sender: Any) {
        for playerName in playerNames {
            if addPlayerNameTextField.text!.lowercased() == playerName.lowercased() {
                return
            }
        }
//        0...playerNames
        
        //integer in list of integers (AKA a range) -- WORKING WITH NUMBERS
        //String in list of Strings - NOT WORKING WITH NUMBERS
        
        
        //add playerNameTextField's text to playerNames array
        playerNames.append(addPlayerNameTextField.text!)
        //reload the TableView to display new player name
        playerNamesTableView.reloadData()
        addPlayerNameTextField.text = ""
        addPlayerButton.isEnabled = false
    }
    
    // When a player name text field value changes
    @IBAction func addPlayerNameTextFieldValueChanged(_ sender: Any) {
        //enable of disable the add player button based on whether or not the textfield is blank
        var shouldEnable:Bool = (addPlayerNameTextField.text != "")
        addPlayerButton.isEnabled = shouldEnable
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clearPlayerNames()
    }
    
    //Table view source protocol function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
    }
    
    //Table view source protocol function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playerNames[indexPath.row]
        return cell
    }
    
    //Table view delegate function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User tapped on row #\(indexPath.row+1) which is \(playerNames[indexPath.row])")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        print( segue.identifier )
        if segue.identifier! == "startGameSegue" {
            var gameViewController:GameViewController = vc as! GameViewController
            gameViewController.playerNames = playerNames
        }
    }

    //if firsttimeviewDidAppear then true
        //otherwise false
    
    override func viewDidAppear(_ animated: Bool) {
        
        if testMode && firstTimeViewDidAppear {
            firstTimeViewDidAppear = false
            return
        }
        
        clearPlayerNames()
    }
    

    func clearPlayerNames(){
        playerNames = []
        playerNamesTableView.reloadData()
    }
    
}

