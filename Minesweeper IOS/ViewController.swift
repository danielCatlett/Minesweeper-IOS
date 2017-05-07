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
    var boardImages = [[UIImage]]()
    var numRows = 8
    var numCols = 8
    var gridLayout: GridLayout!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        gridLayout = GridLayout(numberOfCols: numCols)
        collectionView.collectionViewLayout = gridLayout
        collectionView.reloadData()

        
        for y in 0...(numCols - 1)
        {
            let newArray = [UIImage]()
            boardImages.append(newArray)
            for _ in 0...(numRows - 1)
            {
                boardImages[y].append(UIImage(named: "untouched43")!)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        let image = boardImages[coordinate.1][coordinate.0]
        cell.imageView.image = image
        
        return cell
    }
    
    //MARK - UICollectionView Delegate
    //this is the onClick method; indexPath.row specifies which tile was clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let coordinate = indexPathToCoordinate(index: indexPath.row)
        boardImages[coordinate.1][coordinate.0] = UIImage(named: "clear43")!
        collectionView.reloadData()
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
    
    func coordinateToIndexPath(x: Int, y: Int) -> Int
    {
        return y * numCols + x
    }
}
















