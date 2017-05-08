//  ViewController.swift
//  Minesweeper IOS
//
//  Created by Daniel Catlett on 5/5/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var mineCounter: UILabel!
    @IBOutlet weak var mineButton: UIButton!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageBoard = [[UIImage]]()
    var numRows: Int!
    var numCols: Int!
    var gridLayout: GridLayout!
    var theBoard: Board!
    
    var boardSetUp: Bool!
    var gameIsOver: Bool!
    
    var activeSelectionType: Int!
    
    var minesLeft: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadGame()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func reloadGame()
    {
        numRows = 8
        numCols = 8
        minesLeft = 10
        theBoard = Board(rows: numRows, cols: numCols, mines: minesLeft)
        
        gridLayout = GridLayout(numberOfCols: numCols)
        collectionView.collectionViewLayout = gridLayout
        collectionView.reloadData()
        
        boardSetUp = false
        gameIsOver = false
        
        activeSelectionType = 0
        
        
        mineCounter.text = "Mines Left: 10"
        
        mineButton.setImage(UIImage(named: "minebuttonselected"), for: UIControlState.normal)
        flagButton.setImage(UIImage(named: "flagbutton"), for: UIControlState.normal)
        questionButton.setImage(UIImage(named: "questionbutton"), for: UIControlState.normal)
        
        imageBoard.removeAll()
        for y in 0...(numCols - 1)
        {
            let newArray = [UIImage]()
            imageBoard.append(newArray)
            for _ in 0...(numRows - 1)
            {
                imageBoard[y].append(UIImage(named: "untouched43")!)
            }
        }
        collectionView.reloadData()
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton)
    {
        reloadGame()
    }
    
    @IBAction func mineButtonPressed(_ sender: UIButton)
    {
        if(activeSelectionType != 0)
        {
            activeSelectionType = 0
            mineButton.setImage(UIImage(named: "minebuttonselected"), for: UIControlState.normal)
            flagButton.setImage(UIImage(named: "flagbutton"), for: UIControlState.normal)
            questionButton.setImage(UIImage(named: "questionbutton"), for: UIControlState.normal)
        }
    }
    
    @IBAction func flagButtonPressed(_ sender: UIButton)
    {
        if(activeSelectionType != 1 && boardSetUp)
        {
            activeSelectionType = 1
            mineButton.setImage(UIImage(named: "minebutton"), for: UIControlState.normal)
            flagButton.setImage(UIImage(named: "flagbuttonselected"), for: UIControlState.normal)
            questionButton.setImage(UIImage(named: "questionbutton"), for: UIControlState.normal)
        }
    }
    
    @IBAction func questionButtonPressed(_ sender: UIButton)
    {
        if(activeSelectionType != 2 && boardSetUp)
        {
            activeSelectionType = 2
            mineButton.setImage(UIImage(named: "minebutton"), for: UIControlState.normal)
            flagButton.setImage(UIImage(named: "flagbutton"), for: UIControlState.normal)
            questionButton.setImage(UIImage(named: "questionbuttonselected"), for: UIControlState.normal)
        }
    }
    
    //Mark - UICollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numRows * numCols
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tileCell", for: indexPath) as! CollectionViewCell
        
        let coordinate = indexPathToCoordinate(index: indexPath.item)
        let image = imageBoard[coordinate.1][coordinate.0]
        cell.imageView.image = image
        
        return cell
    }
    
    //MARK - UICollectionView Delegate
    //this is the onClick method; indexPath.row specifies which tile was clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let coordinate = indexPathToCoordinate(index: indexPath.row)
        
        //coordinates of the tile that was tapped
        let x = coordinate.0
        let y = coordinate.1
        
        //if board is not yet set up, set it up
        if(!boardSetUp)
        {
            theBoard.selectMineLocations(maxY: numRows, maxX: numCols, startY: y, startX: x, numMines: minesLeft)
            theBoard.setBoardNums()
            //set the user selected tile to cleared
            theBoard.setState(x: x, y: y, state: 3)
            updateImage(x: x, y: y)
            clearSurroundingTiles(x: x, y: y)
            boardSetUp = true
        }
        else if(!gameIsOver)
        {
            //respond to player interaction
            updateGameState(x: x, y: y, currentState: theBoard.getState(x: x, y: y))
        }
    }
    
    func updateGameState(x: Int, y: Int, currentState: Int)
    {
        switch currentState
        {
        case 0: //if tile is untouched
            tileIsUntouched(x: x, y: y)
        case 1: //if tile is flagged
            if(activeSelectionType == 1) //player is flagging mines
            {
                //restore tile to untouched
                theBoard.setState(x: x, y: y, state: 0)
                updateImage(x: x, y: y)
                
                //add to minesLeft
                minesLeft = minesLeft + 1
                let newText = ("Mines Left: " + String(minesLeft))
                mineCounter.text = newText
            }
        default:
            if(activeSelectionType == 2) //if the player is question marking tiles
            {
                //restore tile to untouched
                theBoard.setState(x: x, y: y, state: 0)
                updateImage(x: x, y: y)
            }
        }
    }
    
    func tileIsUntouched(x: Int, y: Int)
    {
        switch activeSelectionType
        {
        case 0: //if the player is clearing tiles
            clearingUntouchedTile(x: x, y: y)
        case 1: //if the player is flagging tiles
            theBoard.setState(x: x, y: y, state: 1) //flag tile
            updateImage(x: x, y: y)
            
            //decrease minesLeft
            minesLeft = minesLeft - 1
            let newText = ("Mines Left: " + String(minesLeft))
            mineCounter.text = newText
        default: //if the player is question marking tiles
            theBoard.setState(x: x, y: y, state: 2) //question mark the tile
            updateImage(x: x, y: y)
        }
    }
    
    func clearingUntouchedTile(x: Int, y: Int)
    {
        if(!theBoard.checkIfMine(x: x, y: y)) //if the tile is not a mine
        {
            theBoard.setState(x: x, y: y, state: 3) //clear it
            
            if(!theBoard.playerWon()) //if the player didn't win
            {
                updateImage(x: x, y: y)
                
                //if the tile is a 0, clear all tiles around it
                if(theBoard.getNum(x: x, y: y) == 0)
                {
                    clearSurroundingTiles(x: x, y: y)
                }
            }
            else
            {
                updateImage(x: x, y: y)
                mineCounter.text = "You Win!"
                gameIsOver = true
            }
        }
        else
        {
            gameOver()
        }
        
    }
    
    func gameOver()
    {
        for y in 0...(numRows - 1)
        {
            for x in 0...(numCols - 1)
            {
                if(theBoard.checkIfMine(x: x, y: y))
                {
                    imageBoard[y][x] = UIImage(named: "mine43")!
                }
                else
                {
                    setCorrectNumForImage(x: x, y: y, num: theBoard.getNum(x: x, y: y))
                }
            }
        }
        mineCounter.text = "Game Over"
        gameIsOver = true
    }
    
    //since accessing the icons means using an indexPath and not a coordinate system
    //these 2 methods convert indexPaths to coordinates, and vice versa
    func indexPathToCoordinate(index: Int) -> (x: Int, y: Int)
    {
        var coordinate = (x: 0, y: 0)
        coordinate.0 = (index % numCols)
        coordinate.1 = (index / numRows)
        
        return coordinate
    }
    
    //when a tile on theBoard gets a new state, this method is called
    //it ensures the proper image is displayed in the corresponding tile
    //in the Collection View
    func coordinateToIndexPath(x: Int, y: Int) -> Int
    {
        return y * numCols + x
    }
    
    func updateImage(x: Int, y: Int)
    {
        let state = theBoard.getState(x: x, y: y)
        
        switch state
        {
        case 0:
            imageBoard[y][x] = UIImage(named: "untouched43")!
            collectionView.reloadData()
        case 1:
            imageBoard[y][x] = UIImage(named: "flagged43")!
            collectionView.reloadData()
        case 1:
            imageBoard[y][x] = UIImage(named: "question43")!
            collectionView.reloadData()
        default:
            setCorrectNumForImage(x: x, y: y, num: theBoard!.getNum(x: x, y: y))
        }
    }
    
    func setCorrectNumForImage(x: Int, y: Int, num: Int)
    {
        switch num
        {
        case 0:
            imageBoard[y][x] = UIImage(named: "clear43")!
            collectionView.reloadData()
        case 1:
            imageBoard[y][x] = UIImage(named: "one43")!
            collectionView.reloadData()
        case 2:
            imageBoard[y][x] = UIImage(named: "two43")!
            collectionView.reloadData()
        case 3:
            imageBoard[y][x] = UIImage(named: "three43")!
            collectionView.reloadData()
        case 4:
            imageBoard[y][x] = UIImage(named: "four43")!
            collectionView.reloadData()
        case 5:
            imageBoard[y][x] = UIImage(named: "five43")!
            collectionView.reloadData()
        case 6:
            imageBoard[y][x] = UIImage(named: "six43")!
            collectionView.reloadData()
        default:
            imageBoard[y][x] = UIImage(named: "seven43")!
            collectionView.reloadData()
        }
    }
    
    func clearSurroundingTiles(x: Int, y: Int)
    {
        if(y > 0 && x > 0)
        {
            handleTileClearing(x: x - 1, y: y - 1)
        }
        if(y > 0)
        {
            handleTileClearing(x: x, y: y - 1)
        }
        if(x < 7 && y > 0)
        {
            handleTileClearing(x: x + 1, y: y - 1)
        }
        if(x > 0)
        {
            handleTileClearing(x: x - 1, y: y)
        }
        if(x < 7)
        {
            handleTileClearing(x: x + 1, y: y)
        }
        if(x > 0 && y < 7)
        {
            handleTileClearing(x: x - 1, y: y + 1)
        }
        if(y < 7)
        {
            handleTileClearing(x: x, y: y + 1)
        }
        if(x < 7 && y < 7)
        {
            handleTileClearing(x: x + 1, y: y + 1)
        }
    }
    
    func handleTileClearing(x: Int, y: Int)
    {
        //if not a mine, and tile is untouched
        if(theBoard.getState(x: x, y: y) == 0 && !theBoard.checkIfMine(x: x, y: y))
        {
            theBoard.setState(x: x, y: y, state: 3)
            updateImage(x: x, y: y)
            
            //if the newly cleared tile is a 0, recursively call
            if(theBoard.getNum(x: x, y: y) == 0)
            {
                clearSurroundingTiles(x: x, y: y)
            }
        }
    }
}
















