//
//  PodcastsTableViewController.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsTableViewController: UITableViewController, XMLParserDelegate {

    var podcastArray:[Podcast] = []
    var currentPodcast:Podcast?
    var itemFound = false
    var currentElement:String?
    var infoEnd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeeds()
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
        
        return cell
     }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

class Podcast: NSObject {
    var title:String?
    var information: String?
    var streamingLink:URL?
    
    init(title: String?, information:String?, mediaURL:URL?) {
        self.title = title
        self.information = information
        self.streamingLink = mediaURL
    }
}
