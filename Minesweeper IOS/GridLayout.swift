//  GridLayout.swift
//  Minesweeper IOS
//
//  Created by Daniel Catlett on 5/6/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import UIKit

class GridLayout: UICollectionViewFlowLayout
{
    var numberOfCols: Int = 3
    
    init(numberOfCols: Int)
    {
        super.init()
        self.numberOfCols = numberOfCols
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        get
        {
            if let collectionView = collectionView
            {
                let collectionViewWidth = collectionView.frame.width
                let itemWidth = (collectionViewWidth / CGFloat(self.numberOfCols)) - self.minimumInteritemSpacing
                let itemHeight: CGFloat = 43
                
                return CGSize(width: itemWidth, height: itemHeight)
            }
            
            return CGSize(width: 100, height: 100)
        }
        set
        {
            super.itemSize = newValue
        }
        
    }
}
