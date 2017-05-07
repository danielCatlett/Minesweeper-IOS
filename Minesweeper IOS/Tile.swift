//  Tile.swift
//  Minesweeper IOS
//
//  Created by Daniel Catlett on 5/6/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import Foundation

class Tile
{
    //0 is untouched, 1 is flagged, 2 is question marked, 3 is exposed
    var state = 0
    
    //is or isn't a mine
    var mine = false
    
    //number of mines touching tile
    var num = 0
    
    func getState() -> Int
    {
        return state
    }
    
    func setState(newState: Int)
    {
        state = newState
    }
    
    func getMine() -> Bool
    {
        return mine
    }
    
    func makeMine()
    {
        mine = true
    }
    
    func getNum() -> Int
    {
        return num
    }
    
    func setNum(n: Int)
    {
        num = n
    }
}
