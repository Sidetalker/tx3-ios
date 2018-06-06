//
//  ViewController.swift
//  tx3
//
//  Created by Mason Phillips on 6/6/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon

class ViewController: UIViewController {
    
    // Create an always-accessible variable
    // to determine who's turn it is
    // false = "X"
    // true  = "O"
    var turn: Bool = false
    var gameOver: Bool = false
    var grid: Array<Array<String>> =
    [
        [ "", "", ""],
        [ "", "", ""],
        [ "", "", ""]
    ]

    // Top boxes - left/middle/right
    var box_tl: UIButton! = UIButton()
    var box_tm: UIButton! = UIButton()
    var box_tr: UIButton! = UIButton()
    
    // Center boxes - left/middle/right
    var box_cl: UIButton! = UIButton()
    var box_cm: UIButton! = UIButton()
    var box_cr: UIButton! = UIButton()
    
    // Bottom boxes - left/middle/right
    var box_bl: UIButton! = UIButton()
    var box_bm: UIButton! = UIButton()
    var box_br: UIButton! = UIButton()
    
    // Reset Button
    var button_reset: UIButton! = UIButton()
    
    // Turn Label
    var label_turn: UILabel! = UILabel()
    // Winner/Error label
    var label_info: UILabel! = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add all boxes to the view
        // and their actions and tags
        // Top to bottom, left to right
        // The first digit in the tag
        // gives the position in the rows,
        // the second is the position in columns
        view.addSubview(box_tl)
        box_tl.tag = 11
        box_tl.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_tm)
        box_tm.tag = 12
        box_tm.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_tr)
        box_tr.tag = 13
        box_tr.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)

        view.addSubview(box_cl)
        box_cl.tag = 21
        box_cl.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_cm)
        box_cm.tag = 22
        box_cm.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_cr)
        box_cr.tag = 23
        box_cr.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)

        view.addSubview(box_bl)
        box_bl.tag = 31
        box_bl.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_bm)
        box_bm.tag = 32
        box_bm.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        view.addSubview(box_br)
        box_br.tag = 33
        box_br.addTarget(self, action: #selector(ViewController.game), for: .touchUpInside)
        
        // Add reset button
        view.addSubview(button_reset)
        button_reset.setTitle("Reset", for: .normal)
        button_reset.setTitleColor(.blue, for: .normal)
        button_reset.isHidden = true
        button_reset.addTarget(self, action: #selector(ViewController.resetGame), for: .touchUpInside)
        
        // Add turn label to view and center text
        label_turn.textAlignment = .center
        label_turn.text = "Player Turn: X"
        view.addSubview(label_turn)
        
        // Add winner/error label to view and center text
        label_info.textAlignment = .center
        view.addSubview(label_info)
    }
    
    override func viewWillLayoutSubviews() {
        /*
         *  box_cm will act as our center anchor
         *  everything else will be anchored relatively
         *  around it.
         *  Both box_tm and _bm will anchor to _cm
         *  and the left and right boxes will anchor to
         *  to their respective middle boxes
         *
         *  Also, anchor turn_label to the top edge
         *  of the screen and info_label to bottom
         *
         *  Make sure to set the Reset button as well
         *
         *  This will occur every time the screen is resized
         *  (e.g. on device rotation)
         */
        
        /*
         *  Anchor turn_label to top edge
         *  This will anchor the label to the top,
         *  add 15px of padding to the sides, 45px
         *  of padding from the top, and make it 21px
         *  tall
         */
        label_turn.anchorAndFillEdge(.top, xPad: 15, yPad: 45, otherSize: 21)
        label_info.anchorAndFillEdge(.bottom, xPad: 15, yPad: 50, otherSize: 21)
        
        button_reset.anchorInCorner(.bottomRight, xPad: 10, yPad: 20, width: 80, height: 21)
        
        // Anchor _cm to the center of the screen
        box_cm.anchorInCenter(width: 55, height: 55)
        
        // Anchor the center left and right boxes to the center
        box_cl.align(.toTheLeftCentered, relativeTo: box_cm, padding: 0, width: 55, height: 55)
        box_cr.align(.toTheRightCentered, relativeTo: box_cm, padding: 0, width: 55, height: 55)
        
        // Anchor the top and bottom middle boxes to the center
        box_tm.align(.aboveCentered, relativeTo: box_cm, padding: 0, width: 55, height: 55)
        box_bm.align(.underCentered, relativeTo: box_cm, padding: 0, width: 55, height: 55)
        
        // Anchor the top left and right boxes to the top center
        box_tl.align(.toTheLeftCentered, relativeTo: box_tm, padding: 0, width: 55, height: 55)
        box_tr.align(.toTheRightCentered, relativeTo: box_tm, padding: 0, width: 55, height: 55)
        
        // Anchor the bottom left and right boxes to the bottom center
        box_bl.align(.toTheLeftCentered, relativeTo: box_bm, padding: 0, width: 55, height: 55)
        box_br.align(.toTheRightCentered, relativeTo: box_bm, padding: 0, width: 55, height: 55)
    }

    override func viewDidAppear(_ animated: Bool) {
        /*
         *  Setting up the borders to make sure
         *  everything looks nice and pretty
         *  Starting top to bottom, left to right
         */

        box_tl.layer.borderColor = UIColor.black.cgColor
        box_tl.layer.borderWidth = 0.5
        box_tm.layer.borderColor = UIColor.black.cgColor
        box_tm.layer.borderWidth = 0.5
        box_tr.layer.borderColor = UIColor.black.cgColor
        box_tr.layer.borderWidth = 0.5
        
        box_cl.layer.borderColor = UIColor.black.cgColor
        box_cl.layer.borderWidth = 0.5
        box_cm.layer.borderColor = UIColor.black.cgColor
        box_cm.layer.borderWidth = 0.5
        box_cr.layer.borderColor = UIColor.black.cgColor
        box_cr.layer.borderWidth = 0.5
        
        box_bl.layer.borderColor = UIColor.black.cgColor
        box_bl.layer.borderWidth = 0.5
        box_bm.layer.borderColor = UIColor.black.cgColor
        box_bm.layer.borderWidth = 0.5
        box_br.layer.borderColor = UIColor.black.cgColor
        box_br.layer.borderWidth = 0.5

    }

    /**
        This function is called whenever a button is pushed.
        It determines who's turn it is, and marks the appropriate
        button with the right letter, then updates the turn label
        and variable
     
        - Parameter sender: The button that was pushed
     */
    @IBAction func game(sender b: UIButton) {
        if(gameOver) { return }
        // The grid location to check
        let location: String = String(b.tag)
        // Take the tag, split it into row and column
        let row = Int(String(location.first!))! - 1
        let column = Int(String(location.last!))! - 1
        // Don't need an off-by-one error, let's subtract one from the position to check
        
        // Do nothing if a position has already been filled
        if (!checkIsFilled(row: row, column: column)) {
            label_info.text = "That location has already been played in!"
            return
        } else {
            // Clear the warnings from last time
            label_info.text = ""
        }
        
        // The text to put in the button
        let fill: String = ((turn) ? "O" : "X")
        
        // Put the text inside the button
        b.setTitle(fill, for: .normal)
        b.setTitleColor(.red, for: .normal)
        
        // Assign the new letter
        self.fill(row: row, column: column, played: fill)
        
        // Check if someone's won
        let t = checkVictory(row: row, column: column, lastPlayed: fill)
        
        // What to do if they have
        switch t {
        case 1: gameOver(info: "X Wins!"); return // Player 1 (X) wins
        case 2: gameOver(info: "O Wins!"); return // Player 2 (O) wins
        case 3: gameOver(info: "Draw!");   return // Draw
        case 0: fallthrough // This just means "ignore me, move to the next one"
        default: break // Keep playing
        }
        
        // Change turns (it's a Bool, all we have to do is reverse it)
        turn = !turn
        label_turn.text = "Player Turn: \(((turn) ? "O" : "X"))"
        
    }
    
    /**
        Resets the game board
     
     */
    @IBAction func resetGame() {
        // Reset both bools so we start at the right turn
        gameOver = false
        turn = false
        
        // Empty out the grid
        grid = [["","",""],["","",""],["","",""]]
        
        // Reset the text in the boxes
        box_tl.setTitle("", for: .normal)
        box_tm.setTitle("", for: .normal)
        box_tr.setTitle("", for: .normal)
        
        box_cl.setTitle("", for: .normal)
        box_cm.setTitle("", for: .normal)
        box_cr.setTitle("", for: .normal)

        box_bl.setTitle("", for: .normal)
        box_bm.setTitle("", for: .normal)
        box_br.setTitle("", for: .normal)

        // Hide the reset button (we don't need it right now)
        button_reset.isHidden = true
        
        // Clear the previous text
        label_info.text = ""
    }
    
    /**
        Helper function to be called by game() when game is over
     
        - Parameter info: The text to display in info_label
     */
    func gameOver(info: String) {
        label_info.text = info // Set the winner text
        gameOver = true // Tell the game that it's over
        button_reset.isHidden = false // Reveal the hidden button
    }
    
    /**
        Determines whether something already exists
        in a particular location.
 
        - Parameter row: The row in the grid to check
        - Parameter column: The column in the grid to check
     
        - Returns: Bool - True if empty, False if not
    */
    func checkIsFilled(row x: Int, column y: Int) -> Bool {
        
        return (grid[x][y] == "")
    }
    
    /**
        Fills the grid variable after a move
     
        - Parameter row: The row in the grid to check
        - Parameter column: The column in the grid to check
     
        - Parameter played: What to fill
    */
    func fill(row x: Int, column y: Int, played: String) {
        grid[x][y] = played
    }
    
    /**
        Checks whether the game is over, and who won
     
        - Parameter row: The row last played in
        - Parameter column: The column last played in
        - Parameter lastPlayed: The last person to play
     
        - Returns: Int - 0 if game continues, 1 if X wins, 2 if Y wins, 3 if draw
     */
    func checkVictory(row x: Int, column y: Int, lastPlayed p: String) -> Int {
        /*
         *  How does this section work?
         *  First, we check a vertical win. Since we know the last played
         *  line was row,column (passed in), we can use that to start.
         *
         *  For a vertical win, we take the column, and check all the other
         *  rows matching that column. For example: if "O" was last placed in
         *  column 2, then y = 2, and we check the other rows (0,2 1,2 and 2,2)
         *  If they all match, we have a win
         *
         *  For a horizontal win, we take the row, and check all the other columns
         *  matching that row. For example: if "O" was last placed in row 1, then
         *  x = 1, and we check the other columns (1,0 1,1 and 1,2)
         *  If they all match, we have a win
         *
         *  For diagonals, we first check to see which direction we're going. We can
         *  do that with x == y (i.e. we're starting from either 0,0 1,1 or 2,2) or if
         *  they equal 2 (i.e. we're starting from either 0,2 1,1 or 2,0). If true,
         *  then we check those corresponding columns and rows, and see if we won
         *
         *  Finally, we check for a draw. We loop through the grid variable, and if we
         *  come upon an empty cell (i.e. ""), then we set the flag and we're done. If
         *  we don't, then the flag remains set to "false" and we send back 3, or "draw"
         */
        
        
        // Check vertical win
        if (grid[0][y] == grid[1][y] && grid[1][y] == grid[2][y]) { return ((p == "X") ? 1 : 2) }
        
        // Check horizontal win
        if (grid[x][0] == grid[x][1] && grid[x][1] == grid[x][2]) { return ((p == "X") ? 1 : 2) }
        
        // Check main diagonal win (1,1 - 2,2 - 3,3)
        if ((x == y) && (grid[0][0] == grid[1][1]) && (grid[1][1] == grid[2][2])) { return ((p == "X") ? 1 : 2) }
        
        // Check secondary diagonal win (1,3 - 2,2 - 3,1)
        if((x + y == 2) && (grid[0][2] == grid[1][1]) && (grid[1][1] == grid[2][0])) { return ((p == "X") ? 1 : 2)}
        
        // Check board is full
        var flag: Bool = false
        grid.forEach { (row) in
            row.forEach({ (cell) in
                if cell == "" { flag = true }
            })
        }
        
        return ((flag) ? 0 : 3)
    }
    
}
