//
//  RecentsTableViewController.swift
//  What Are They In
//
//  Created by Brandon Ching on 4/8/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController, RecentCellDelegate {
    
    var recents: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let recentOne = UserDefaults.standard.string(forKey: "recentOne") ?? ""
        let recentTwo = UserDefaults.standard.string(forKey: "recentTwo") ?? ""
        let recentThree = UserDefaults.standard.string(forKey: "recentThree") ?? ""
        let recentFour = UserDefaults.standard.string(forKey: "recentFour") ?? ""
        let recentFive = UserDefaults.standard.string(forKey: "recentFive") ?? ""
        let recentSix = UserDefaults.standard.string(forKey: "recentSix") ?? ""
        
        if recentOne != "" {
            recents.append(recentOne)
        }
        if recentTwo != "" {
            recents.append(recentTwo)
        }
        if recentThree  != "" {
            recents.append(recentThree)
        }
        if recentFour != "" {
            recents.append(recentFour)
        }
        if recentFive != "" {
            recents.append(recentFive)
        }
        if recentSix != "" {
            recents.append(recentSix)
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recents.count
    }
    
    func didTapViewActor() {
        performSegue(withIdentifier:"toInfo", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell") as! RecentCell
        cell.setText(name: recents[indexPath.row])
        cell.delegate = self as RecentCellDelegate
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
