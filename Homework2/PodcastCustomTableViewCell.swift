//
//  PodcastCustomTableViewCell.swift
//  Homework2
//
//  Created by Ayyanchira, Akshay Murari on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit

class PodcastCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var podcastInfoView: UITextView!
    @IBOutlet weak var addTopPlaylistButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addToPlaylistPressed(_ sender: UIButton) {
    }
}
