//
//  SettingsTableViewController.swift
//  MaestroApp
//
//  Created by Nadir on 19/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let preferences = UserDefaults.standard
    let apiKeyObjectKey : String = "apiKey"
    let apiUrlObjectKey : String = "apiUrl"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBOutlet weak var cellLogOut: UITableViewCell!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theSelectedCell = tableView.cellForRow(at: indexPath)
        if cellLogOut == theSelectedCell {
            preferences.removeObject(forKey: apiKeyObjectKey)
            preferences.removeObject(forKey: apiUrlObjectKey)
        }
        
    }    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "apiInfoSegue" {
            let nav = segue.destination as! ApiInfoViewController
            nav.isRoot = false
        }
    }
}
