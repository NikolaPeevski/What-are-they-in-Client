//
//  RecentCell.swift
//  What Are They In
//
//  Created by Brandon Ching on 4/8/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit

var actorName = ""

protocol RecentCellDelegate {
    
    func didTapViewActor()
}

class RecentCell: UITableViewCell {
    
    var delegate: RecentCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setText(name: String) {
        nameLabel.text = name
    }
    
    
    @IBAction func viewActor(_ sender: Any) {
        actorName = nameLabel.text!
        delegate?.didTapViewActor()
    }
}
