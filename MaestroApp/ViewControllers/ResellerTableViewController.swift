//
//  ResellerTableViewController.swift
//  MaestroPanel
//

import UIKit

class ResellerTableViewController: UITableViewController {
    
    
    var ResllerList : NSMutableArray=[]
    var maestro : ResellerManager = ResellerManager()
    var StatusImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    

        present(AlertViewController.getUIAlertLoding("Bayiler yükleniyor"), animated: true, completion: nil)
        
        maestro.getResellerList{result in
            self.ResllerList = result
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
        return ResllerList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resellerCell", for: indexPath) as! ResellerListTableViewCell
        
        let reseller = ResllerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        
        
        var imageForStatus : UIImage
        
       if reseller.Status == "1" {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
 
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblNameLastname.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblNameLastname.text = ("\(reseller.FirstName!) \(reseller.LastName!)")
        
        cell.LblKullaniciAdi.text = "Kullanıcı Adı : "
        cell.LblKullaniciAdi.font = UIFont(name: "HelveticaNeue", size: 11)
        
        cell.LblUsername.text = reseller.Username
        cell.LblUsername.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        cell.LblSonlanmaTarihi.text = "Sonlanma Tarihi : "
        cell.LblSonlanmaTarihi.font = UIFont(name: "HelveticaNeue", size: 11)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.LblExpirationDate.text = dateFormatter.string(from: reseller.ExpirationDate as Date)
        cell.LblExpirationDate.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
