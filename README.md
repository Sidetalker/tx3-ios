# Tx3 (Tic Tac Toe)  
This is a very simple Tic-Tac-Toe game for iOS using Neon to lay out the views  
This application was designed to be a quick sample  

Also check out [this StackExchange answer](https://codereview.stackexchange.com/a/24890) for a reference to the checkVictory() function

## Documentation

### ViewController.swift
#### An explanation  
Why choose to use both `viewDidAppear` and `viewDidLoad`? `viewDidLoad` is used to place all the elements inside the view, both buttons and labels. `viewDidAppear` is used to style the elements. While this is not necessary to do, it personally feels more clean and seperated.

#### - viewDidLoad()
Add all the buttons and their tags/targets, and labels.

#### - viewDidAppear()
Add the styling to all visual elements

#### - viewWillLayoutSubviews()
Position all elements any time there's a change in appearance. This ensures the app will always position them relative to the screen, even if rotated

`box_cm` will act as our center anchor everything else will be anchored relatively around it.  
Both `box_tm` and `_bm` will anchor to `_cm` and the left and right boxes will anchor to to their respective middle boxes  
Also, anchor turn_label to the top of the boxes and info_label to bottom  
Make sure to set the Reset button as well  
This will occur every time the screen is resized (e.g. on device rotation)  

#### - game()
Our bread and butter. This function actually plays through the game. First, it grabs the tag set earlier, then breaks it down into row and column (hereafter known as x and y, respectively). Then we call `checkIsFilled` to see if we've already played there (see function reference). If it is, set the info label to alert the player. If not, make sure the info label is clear. Then, go ahead and place the letter ("X" or "O" depending on turn) in the `grid` variable so we can check for it later. Also put the player's letter inside the button and style the button correctly (we do this here because it's easier than doing it for each and every one and doesn't have to be rendered when the app starts). We then check to see if the game is over (`checkVictory`) and perform an action based on the result (see function reference). If we're still playing, flip the Bool and put the next player's turn in the turn label.

#### - checkIsFilled()
Checks to see if x and y has already been played in a particular grid square. Verifies this by checking the `grid` variable.

#### - fill()
Fills the grid variable after a move is selected. 

#### - resetGame()
Resets the game board. Called by pressing the "Play Again!" button. Clears out the grid, resets the `gameOver` and `turn` variables to their initial state, empties the buttons of text, hides the reset button, and clears out the labels

#### - gameOver()
A small helper function that makes it easier to display info when the game is over. Shows the winner (or if draw) in the info label, sets gameOver to true (check `game()`, if the game is over when a button is pressed it does nothing), and shows the reset button

#### - checkVictory()
How does this section work?
First, we check a vertical win. Since we know the last played line was row,column (passed in), we can use that to start.  

For a vertical win, we take the column, and check all the other rows matching that column. For example: if "O" was last placed in column 2, then y = 2, and we check the other rows (0,2 1,2 and 2,2). If they all match, we have a win

For a horizontal win, we take the row, and check all the other columns matching that row. For example: if "O" was last placed in row 1, then x = 1, and we check the other columns (1,0 1,1 and 1,2). If they all match, we have a win

For diagonals, we first check to see which direction we're going. We can do that with x == y (i.e. we're starting from either 0,0 1,1 or 2,2) or if they equal 2 (i.e. we're starting from either 0,2 1,1 or 2,0). If true, then we check those corresponding columns and rows, and see if we won

Finally, we check for a draw. We loop through the grid variable, and if we come upon an empty cell (i.e. ""), then we set the flag and we're done. If we don't, then the flag remains set to "false" and we send back 3, or "draw"

If there's a win, we highlight the winning boxes in green

#### - highlight()
Highlights a box by x and y
