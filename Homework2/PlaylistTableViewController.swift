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

    var playerController:AVQueuePlayer = AVQueuePlayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        print("View Appeared")
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
            tableView.reloadData()
        }
    }
    
    @IBAction func playAllPressed(_ sender: UIBarButtonItem) {
        let currentItem = playerController.currentItem
        if currentItem == nil {
            playAll()
        }
        else{
            if playerController.rate == 1.0{
                playerController.pause()
            }
            else{
                playerController.play()
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class PlaylistCell: UITableViewCell {
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
}
