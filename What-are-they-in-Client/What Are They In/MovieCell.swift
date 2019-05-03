//
//  movieCell.swift
//  What Are They In
//
//  Created by Brandon Ching on 4/25/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit

protocol MovieCellDelegate {
    
    func didTapViewMovie()
    
}

class MovieCell: UITableViewCell {
    
    var delegate: MovieCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setText(title: String) {
        
        titleLabel.text = title
    }
    
    @IBAction func toIMDB(_ sender: Any) {
        movieTitle = titleLabel.text!
        delegate?.didTapViewMovie()
    }
    
}
