//
//  PlaylistTableViewController.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVKit
class PlaylistTableViewController: UITableViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var playAllButton: UIBarButtonItem!
    var playerController:AVQueuePlayer = AVQueuePlayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Playlist.sharedInstance.playlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "podcastcell", for: indexPath) as! PlaylistCell
        let podcast = Playlist.sharedInstance.playlist[indexPath.row]
        cell.podcastTitleLabel.text = podcast.title
        cell.deleteButton.tag = indexPath.row
        // Configure the cell...
        return cell
    }
 
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if playerController.items().count>0{
            let avItem = playerController.items()[sender.tag]
            playerController.remove(avItem)
            print(playerController.items().count)
        }
        
        if(Playlist.sharedInstance.removePodcastAtIndex(index: sender.tag)){
            if Playlist.sharedInstance.playlist.count==0 {
                let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(PlaylistTableViewController.playAllPressed(_:)))
                navBar.rightBarButtonItem = newBarButton
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func playAllPressed(_ sender: UIBarButtonItem) {
        let currentItem = playerController.currentItem
        if currentItem == nil {
            if Playlist.sharedInstance.playlist.count == 0{
                let alertController = UIAlertController(title: "Playlist Empty", message: "Please go back and add some podcasts to play all together", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                playAll()
                let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(PlaylistTableViewController.playAllPressed(_:)))
                
                navBar.rightBarButtonItem = newBarButton
            }
            
        }
        else{
            if playerController.rate == 1.0{
                playerController.pause()
                let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(PlaylistTableViewController.playAllPressed(_:)))
                navBar.rightBarButtonItem = newBarButton
            }
            else{
                playerController.play()
                let newBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(PlaylistTableViewController.playAllPressed(_:)))
                
                navBar.rightBarButtonItem = newBarButton
            }
        }
    }
    
    func playAll(){
        var podcasts:[AVPlayerItem] = []
        for items in Playlist.sharedInstance.playlist{
            let podcast = AVPlayerItem(url: items.streamingLink!)
            podcasts.append(podcast)
        }
        playerController = AVQueuePlayer(items: podcasts)
        playerController.play()
    }

}

class PlaylistCell: UITableViewCell {
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
}
