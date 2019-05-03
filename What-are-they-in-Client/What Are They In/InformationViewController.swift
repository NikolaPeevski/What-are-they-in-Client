//
//  InformationViewController.swift
//  What Are They In
//
//  Created by Brandon Ching on 3/28/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit

var movieTitle = ""

class InformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MovieCellDelegate  {
    
    @IBOutlet weak var currActorLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        currActorLabel.text = actorName
        birthdayLabel.text = "Birthday: \(birthday)"
        picture.downloaded(from: imagePath, contentMode: .scaleAspectFit)
        
    }
    
    @IBAction func toIMDB(_ sender: Any) {
        // actors IMDB
        if let url = URL(string: "https://www.imdb.com/name/\(id)/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.setText(title: movies[indexPath.row])
        cell.delegate = self as MovieCellDelegate
        
        return cell
    }
    
    func didTapViewMovie() {
        // movie IMDB
//        if let url = URL(string: ) {
//            UIApplication.shared.open(url, options: [:])
//        }
    }
    
}
