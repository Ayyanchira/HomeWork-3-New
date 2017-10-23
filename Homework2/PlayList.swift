//
//  PlayList.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import Foundation
import AVKit
//class PlayList {
//
//    var playlist:[Podcast] = []
//
//    static let sharedInstace = PlayList()
//    func addToPlaylist(podcast:Podcast) -> Bool {
//
//        for podcasts in playlist{
//            return {podcasts == podcast}()
//        }
//        playlist.append(podcast)
//        return true
//    }
//
//    func playPlaylist() {
//
//    }
//
//}

//struct PlayList {
//    static let sharedInstance = PlayList()
//    var playlist:[Podcast] = []
//    mutating func addToPlaylist(podcast:Podcast) -> Bool {
//        for podcasts in playlist{
//            return {podcasts == podcast}()
//        }
//        self.playlist.append(podcast)
//        return true
//    }
//}

class Playlist {
    static let sharedInstance = Playlist()
    private init(){    }
    
    var playlist:[Podcast] = []
    
    func addToPlaylist(podcast:Podcast) -> Bool {
        var status = true
        for item in playlist {
            if item == podcast{
                status = false
                return status
            }
        }
        playlist.append(podcast)
        return status
    }
    
    func removePodcastAtIndex(index:Int) -> Bool {
        
        playlist.remove(at: index)
        return true
    }
    
}
