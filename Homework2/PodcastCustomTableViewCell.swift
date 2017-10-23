//
//  PodcastCustomTableViewCell.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit

class PodcastCustomTableViewCell: UITableViewCell {
    var isPlaying:Bool?
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var podcastInfoView: UITextView!
    @IBOutlet weak var addTopPlaylistButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //showIcon()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected...\(selected) status")
        // Configure the view for the selected state
    }
    

    @IBAction func addToPlaylistPressed(_ sender: UIButton) {
        sender.isHidden = true
    }
    
//    func showIcon() {
//        if let status = isPlaying{
//            if status {
//                isPlaying = false
//                DispatchQueue.main.async {
//                    self.playButton.imageView?.image = #imageLiteral(resourceName: "video-play-icon-6")
//                }
//            }else{
//                isPlaying = true
//                DispatchQueue.main.async {
//                    self.playButton.imageView?.image = #imageLiteral(resourceName: "pause-512")
//                }
//            }
//        }
//
//    }
}
