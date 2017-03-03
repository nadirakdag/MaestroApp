//
//  ServerTableViewController.swift
//  MaestroPanel
//

import Foundation
import UIKit
import Foundation

class ServerTableViewController: UITableViewController {
    
    var serverList : NSMutableArray = []
    let cellIdentitfier : String = "ServerItemIdentifier"
    var StatusImage: UIImageView?
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)


    
    let api : ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yüklendi")
        //tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        api.getServerList { response in
            self.serverList = response
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)

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
        
        print(serverList.count)
        return serverList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitfier, for: indexPath) as! ServerListTableViewCell
        
        print(self.serverList)
        let data = self.serverList[(indexPath as NSIndexPath).row] as! ServerListItemModel
        print(data)
        
        var imageForStatus : UIImage
        
        if data.Status == 1 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblServerName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblServerName.text = data.Name
        cell.LblServerName.font = UIFont(name: "HelveticaNeue", size: 18)

        cell.LblIsletimSistemi.text = "İşletim Sistemi : "
        cell.LblIsletimSistemi.font = UIFont(name: "HelveticaNeue", size: 11)
        
        cell.LblOperatingSystem.text = data.OperatingSystem
        cell.LblOperatingSystem.font = UIFont(name: "HelveticaNeue-light", size: 11)

        cell.LblIpAdresi.text = "IP Adresi : "
        cell.LblIpAdresi.font = UIFont(name: "HelveticaNeue", size: 11)

        cell.LblHost.text = data.Host
        cell.LblHost.font = UIFont(name: "HelveticaNeue-light", size: 11)

        
        //cell.LblServerName.text = data.ComputerName
        //cell.LblServerOperatingSystem.text = data.OperationSystem
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let serverDetailView = segue.destination as! ServerDetailTableViewController
        
        if let serverCell = sender as? ServerListTableViewCell{
            let indexPath = self.tableView.indexPath(for: serverCell)
            let serverModel : ServerListItemModel = self.serverList[((indexPath as NSIndexPath?)?.row)!] as! ServerListItemModel
            
            serverDetailView.serverDetail = serverModel
        }
        
    }
    
    
}
