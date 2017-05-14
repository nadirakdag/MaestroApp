//
//  ResellerIpAddrTableViewController.swift
//  MaestroApp
//
//  Created by Nadir on 14/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import UIKit

class ResellerIpAddrTableViewController: UITableViewController {

    var resellerUserName : String = ""
    let resellerManager : ResellerManager = ResellerManager()
    var ipAddrList : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadDomains(){
        
        let alert = AlertViewController.getUIAlertLoding("\(resellerUserName) isimli bayi için IP adresleri yükleniyor")
        self.present(alert, animated: true, completion: nil)
        
        resellerManager.getIpAddresses(resellerUserName){ result in
            self.ipAddrList = result
            self.tableView.reloadData()
            alert.dismiss(animated: true, completion: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ipAddrList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resellerIpAddrCell", for: indexPath) as! ResellerIpAddrTableViewCell

        let index = (indexPath as NSIndexPath).row
        let ipAddr = ipAddrList[index] as! ResellerIpAddrModel
        
        cell.lblNicName.text = ipAddr.Nic!
        cell.lblIpAddr.text = ipAddr.IpAddr!
        
        if ipAddr.isDedicated! {
            cell.lblStatus.text = "Dedicated IP"
        }
        else if ipAddr.isShared! {
            cell.lblStatus.text = "Shared IP"
        }
        else if ipAddr.isExclusive! {
            cell.lblStatus.text = "Sistem için Özel IP"
        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
