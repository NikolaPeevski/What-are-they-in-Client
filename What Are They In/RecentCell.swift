//
//  RecentCell.swift
//  What Are They In
//
//  Created by Brandon Ching on 4/8/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit


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
        
        let info = UserDefaults.standard.array(forKey: actorName) ?? nil
        
        birthday = info?[0] as! String
        imagePath = info?[1] as! String
        id = info?[2] as! String
        
        movies = []
        
        let count: Int = info?.count ?? 0
        for index in 3..<count {
            movies.append(info?[index] as! String)
        }
        
        delegate?.didTapViewActor()
    }
}
