//  Board.swift
//  Minesweeper IOS
//
//  Created by Daniel Catlett on 5/6/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import Foundation

class Board
{
    //Board is an array of arrays
    //Each array within the array is a row
    var board = [[Tile]]()
    
    init(rows: Int, cols: Int, mines: Int)
    {
        //Add each row
        for y in 0...(rows - 1)
        {
            addRow()
            //Add each tile in each row
            for _ in 0...(cols - 1)
            {
                board[y].append(addTile())
            }
        }
        
        //Pretty sure this is unnecessary, but it will stay for now
        /*
         if(rows > 8)
         {
         for index in (rows - 8)...rows
         {
         addRow()
         //rows probably need to be populated
         }
         }
         if(cols > 8)
         {
         for index in (cols - 8)...cols
         {
         addCol()
         }
         }
         */
        
        initializeTiles()
    }
    
    //Create new array of tiles, and add it to the board
    func addRow()
    {
        let row = [Tile]()
        board.append(row)
    }
    
    /*This is probably unnecessary, but it stays for now
     func addCol()
     {
     for index in 0...(board.count)
     {
     addTile(row: index)
     }
     }
     */
    
    //Add a new tile to the row specified
    func addTile() -> Tile
    {
        let x = Tile()
        return x
    }
    
    func createTile() -> Tile
    {
        let x = Tile()
        return x
    }
    
    //Before this method is called, the board is filled with rows,
    //But the rows have no tiles in them.
    //This method fills the rows with tiles
    func initializeTiles()
    {
        let rows = board.count
        let cols = board[0].count - 1
        for y in 0...(rows - 1)
        {
            //print("Y: ", y)
            //print(cols)
            for x in 0...(cols)
            {
                //print("X: ", x)
                board[y][x] = createTile()
            }
        }
    }
    
    func selectMineLocations(maxY: Int, maxX: Int, startY: Int, startX: Int, numMines: Int)
    {
        //Arrays storing the coordinates of the starting tile and each mine
        //Checks this to make sure a mine isn't placed where it isn't supposed to be
        var unusableY = [Int]()
        var unusableX = [Int]()
        
        //First tile the player chose is added
        unusableY.append(startY)
        unusableX.append(startX)
        
        //All tiles around the initial tile are added
        //Checks to make sure each of the 8 border tiles do in fact exist
        //(In case the user picked an edge)
        if(startY > 0 && startX > 0)
        {
            unusableX.append(startX - 1);
            unusableY.append(startY - 1);
        }
        if(startY > 0)
        {
            unusableX.append(startX);
            unusableY.append(startY - 1);
        }
        if(startX < maxX && startY > 0)
        {
            unusableX.append(startX + 1);
            unusableY.append(startY - 1);
        }
        if(startX > 0)
        {
            unusableX.append(startX - 1);
            unusableY.append(startY);
        }
        if(startX < maxX)
        {
            unusableX.append(startX + 1);
            unusableY.append(startY);
        }
        if(startX > 0 && startY < maxY)
        {
            unusableX.append(startX - 1);
            unusableY.append(startY + 1);
        }
        if(startY < maxY)
        {
            unusableX.append(startX);
            unusableY.append(startY + 1);
        }
        if(startX < maxX && startY < maxY)
        {
            unusableX.append(startX + 1);
            unusableY.append(startY + 1);
        }
        
        for _ in 0...(numMines - 1)
        {
            var x = Int(arc4random_uniform(UInt32(maxX)))
            var y = Int(arc4random_uniform(UInt32(maxY)))
            
            while(notUsable(unusableY: unusableY, unusableX: unusableX, x: x, y: y) || board[y][x].getMine())
            {
                x = Int(arc4random_uniform(UInt32(maxX)))
                y = Int(arc4random_uniform(UInt32(maxY)))
            }

            board[y][x].makeMine();

        }
    }
    
    private func notUsable(unusableY: [Int], unusableX: [Int], x: Int, y: Int) -> Bool
    {
        for index in 0...(unusableX.count - 1)
        {
            if(unusableX[index] == x && unusableY[index] == y)
            {
                return true
            }
        }
        
        return false
    }
    
    func checkIfMine(x: Int, y: Int) -> Bool
    {
        if(board[y][x].getMine())
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func setState(x: Int, y: Int, state: Int)
    {
        board[y][x].setState(newState: state)
    }
    
    func getState(x: Int, y: Int) -> Int
    {
        return board[y][x].getState()
    }
    
    func getNum(x: Int, y: Int) -> Int
    {
        return board[y][x].getNum()
    }
    
    //Gives each tile the number of mines surrounding it
    func setBoardNums()
    {
        /*
         Note for upper bound of the for loops.
         This is supposed to be the count along the y axis,
         I have no idea how board.count will react, since it
         is a 2d array, and that method was designed with a 1d
         array in mind. Hopefully it works...
         update: I'm pretty sure this is right
         */
        /*
         Nums for each tile with 8 tiles surrounding it
         loops through each tile not on an edge, outsources the counting of the
         surrounding mines, and then sets the tile number to the outsourced number
         */
        for y in 1...(board.count - 2) //board.count - 1 would take us to the corner, so we subtract 1 more
        {
            for x in 1...(board[0].count - 2)
            {
                let a = calculateNumsInner(y: y, x: x)
                board[y][x].setNum(n: a)
            }
        }
        
        //nums for upper row (not corners)
        for x in 1...(board[0].count - 2)
        {
            let a = calculateNumsTop(x: x)
            board[0][x].setNum(n: a)
        }
        
        //nums for lower row (not corners)
        for x in 1...(board[0].count - 2)
        {
            let a = calculateNumsBottom(x: x)
            //print("Calculated value of", x)
            board[board.count - 1][x].setNum(n: a)
            //print(x, "set")
        }
        
        //nums for left side (not corners)
        for y in 1...(board.count - 2)
        {
            let a = calculateNumsLeft(y: y)
            board[y][0].setNum(n: a)
        }
        
        //nums on right side (not corners)
        for y in 1...(board.count - 2)
        {
            let a = calculateNumsRight(y: y)
            board[y][board[0].count - 1].setNum(n: a);
        }
        
        //nums for corners
        setNumsForCorners()
    }
    
    func setNumsForCorners()
    {
        var upperLeft = 0
        var upperRight = 0
        var lowerLeft = 0
        var lowerRight = 0
        
        //checks each tile bordering the upper left corner tile,
        //adds one if it is a mine
        if(board[0][1].getMine())
        {
            upperLeft = upperLeft + 1
        }
        if(board[1][0].getMine())
        {
            upperLeft = upperLeft + 1
        }
        if(board[1][1].getMine())
        {
            upperLeft = upperLeft + 1
        }
        board[0][0].setNum(n: upperLeft)
        
        //upper right
        if(board[0][board[0].count - 2].getMine())
        {
            upperRight = upperRight + 1
        }
        if(board[1][board[0].count - 2].getMine())
        {
            upperRight = upperRight + 1
        }
        if(board[1][board[0].count - 1].getMine())
        {
            upperRight = upperRight + 1
        }
        board[0][board[0].count - 1].setNum(n: upperRight)
        
        //lower left
        if(board[board.count - 2][0].getMine())
        {
            lowerLeft = lowerLeft + 1
        }
        if(board[board.count - 2][1].getMine())
        {
            lowerLeft = lowerLeft + 1
        }
        if(board[board.count - 1][1].getMine())
        {
            lowerLeft = lowerLeft + 1
        }
        board[board.count - 1][0].setNum(n: lowerLeft)
        
        //lower right
        if(board[board.count - 2][board[0].count - 2].getMine())
        {
            lowerRight = lowerRight + 1
        }
        if(board[board.count - 2][board[0].count - 1].getMine())
        {
            lowerRight = lowerRight + 1
        }
        if(board[board.count - 1][board[0].count - 2].getMine())
        {
            lowerRight = lowerRight + 1
        }
        board[board.count - 1][board[0].count - 1].setNum(n: lowerRight)
    }
    
    private func calculateNumsRight(y: Int) -> Int
    {
        var numMines = 0
        
        if(board[y - 1][board[0].count - 2].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][board[0].count - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][board[0].count - 2].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][board[0].count - 2].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][board[0].count - 1].getMine())
        {
            numMines = numMines + 1
        }
        
        return numMines
    }
    
    private func calculateNumsLeft(y: Int) -> Int
    {
        var numMines = 0
        
        if(board[y - 1][0].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][0].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][1].getMine())
        {
            numMines = numMines + 1
        }
        
        return numMines
    }
    
    private func calculateNumsBottom(x: Int) -> Int
    {
        var numMines = 0
        let y = board.count - 1
        
        if(board[y - 1][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][x].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        
        return numMines
    }
    
    private func calculateNumsTop(x: Int) -> Int
    {
        var numMines = 0
        
        if(board[0][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[0][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[1][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[1][x].getMine())
        {
            numMines = numMines + 1
        }
        if(board[1][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        
        return numMines
    }
    
    private func calculateNumsInner(y: Int, x: Int) -> Int
    {
        var numMines = 0
        
        if(board[y - 1][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][x].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y - 1][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][x - 1].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][x].getMine())
        {
            numMines = numMines + 1
        }
        if(board[y + 1][x + 1].getMine())
        {
            numMines = numMines + 1
        }
        
        return numMines
    }
    
    //methods migrating here from the main class
    //could probably use some editing, but too lazy
    func playerWon() -> Bool
    {
        var theAnswer = true
        
        //loop through all the tiles
        for y in 0...7
        {
            for x in 0...7
            {
                //if there is a non mine that isn't cleared
                if(!checkIfMine(x: x, y: y) && getState(x: x, y: y) != 3)
                {
                    theAnswer = false
                }
            }
        }

        return theAnswer
    }
    
    //some of this might be salvagable
    //delete what isn't when done
/*
    func getRequestedState(x: Int, y: Int) -> Int
    {
        let currentState = getState(x: x, y: y)
        if(currentState == 0)
        {
            print("Would you like to\n1. Put a flag here\n2. Put a question mark here\n3. Clear this tile\n4. Cancel selecting this tile\nEnter the  number that  corresponds with the option you want.")
            
            let input = readLine()
            let req = Int(input!)!
            while req < 1 || req > 4
            {
                print("Invalid response. Enter a number between 1 and 4")
                let input = readLine()
                let req = Int(input!)!
            }
            
            return req
        }
        else if(currentState == 1)
        {
            print("Would you like to\n1. Remove the flag here\n2. Put a question mark here\n3. Cancel selecting this tile")
            
            var input = readLine()
            var req = Int(input!)!
            while req < 1 || req > 3
            {
                print("Invalid response. Enter a number between 1 and 3")
                input = readLine()
                req = Int(input!)!
            }
            if(req == 1)
            {
                return 0
            }
            else if(req == 3)
            {
                return 4
            }
            else
            {
                return req
            }
        }
        else if(currentState == 2)
        {
            print("Would you like to\n1. Put a flag here\n2. Remove the question mark here\n3. Clear this tile\n4. Cancel selecting this tile")
            
            let input = readLine()
            let req = Int(input!)!
            while req < 1 || req > 4
            {
                print("Invalid response. Enter a number between 1 and 4")
                let input = readLine()
                let req = Int(input!)!
            }
            
            //Removing the q mark, so we want to set the tile back to 0
            if(req == 2)
            {
                return 0
            }
            else
            {
                return req
            }
        }
        else
        {
            return 5
        }
    }
*/
}
