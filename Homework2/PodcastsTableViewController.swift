//
//  PodcastsTableViewController.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import Alamofire
import AVKit
class PodcastsTableViewController: UITableViewController, XMLParserDelegate {

    var podcastArray:[Podcast] = []
    var playerController:AVQueuePlayer = AVQueuePlayer()
    var nowPlaying:Int?
    var currentPodcast:Podcast?
    var itemFound = false
    var currentElement:String?
    var infoEnd = false
    var isPaused = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeeds()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("View appeared")
        isPaused = false
        nowPlaying = nil
        tableView.reloadData()
    }
    //URL connection method
    func getFeeds() {
        let request = NSMutableURLRequest(url: NSURL(string: "http://feed.thisamericanlife.org/talpodcast")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription ?? "Error occured")
            } else {
                DispatchQueue.main.async {
                    let parser = XMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                }
            }
        })
        dataTask.resume()
    }
    
    // PRAGMA MARK: XML Parsing code
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
 
        if elementName == "item" {
            //initializing the object
            currentPodcast = Podcast(title: "", information: "", mediaURL: nil)
            itemFound = true
        }
        else if elementName == "media:content"{
            let stringURL = attributeDict["url"]
            let mediaURL = URL(string: stringURL!)
            currentPodcast?.streamingLink = mediaURL
        }
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
         if elementName == "item" {
            podcastArray.append(currentPodcast!)
            currentPodcast = nil
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Ended")
        tableView.reloadData()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" && itemFound{
            currentPodcast?.title?.append(string)
        }
        else if currentElement == "description"{
            if string == "<"
            {
                infoEnd = true
            }
            else if string == ">"{
                infoEnd = false
                return
            }
            if !infoEnd{ currentPodcast?.information?.append(string)}
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return podcastArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCustomCell", for: indexPath) as! PodcastCustomTableViewCell
        let podcast = podcastArray[indexPath.row]
        cell.podcastLabel.text = podcast.title
        cell.podcastInfoView.text = podcast.information
        cell.playButton.tag = indexPath.row
        cell.playButton.setImage(#imageLiteral(resourceName: "video-play-icon-6"), for: .normal)
        if nowPlaying != nil{
            if nowPlaying == indexPath.row {
                if !isPaused{
                    cell.playButton.setImage(#imageLiteral(resourceName: "pause-512"), for: .normal)
                }
            }
        }
        cell.addTopPlaylistButton.tag = indexPath.row
        return cell
     }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        let podcast = podcastArray[sender.tag]
        let currentItem = playerController.currentItem
        
        let nextSongNumber = sender.tag
        if nextSongNumber == nowPlaying{
            if isPaused{
                playerController.play()
                isPaused = false
            }
            else{
                playerController.pause()
                isPaused = true
            }
            tableView.reloadData()
            return
        }
        if currentItem == nil {
            playerController = AVQueuePlayer(url: podcast.streamingLink!)
            playerController.play()
            nowPlaying = sender.tag
            tableView.reloadData()
        }
        else{
            let nextPodcast = AVPlayerItem(url: podcast.streamingLink!)
            playerController.replaceCurrentItem(with: nextPodcast)
            playerController.play()
            isPaused = false
            nowPlaying = sender.tag
            tableView.reloadData()
        }
    }
    
    @IBAction func addToPlaylistPressed(_ sender: UIButton) {
        let podcast = podcastArray[sender.tag]
        
        if Playlist.sharedInstance.addToPlaylist(podcast: podcast){
            let alertController = UIAlertController(title: "Added Successfully", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Already added", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        playerController.pause()
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

public class Podcast: NSObject {
    var title:String?
    var information: String?
    var streamingLink:URL?
    
    init(title: String?, information:String?, mediaURL:URL?) {
        self.title = title
        self.information = information
        self.streamingLink = mediaURL
    }
}
