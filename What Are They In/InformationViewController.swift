//
//  InformationViewController.swift
//  What Are They In
//
//  Created by Brandon Ching on 3/28/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var currActorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currActorLabel.text = actorName
    }
}
