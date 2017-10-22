//
//  PlayList.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import Foundation
import AVKit
class PlayList: NSObject {
    
    var playlist:[Podcast] = []
    
    func addToPlaylist(podcast:Podcast) -> Bool {
        
        for podcasts in playlist{
            return {podcasts == podcast}()
        }
        playlist.append(podcast)
        return true
    }
    
    func playPlaylist() {
        
    }
    
}
