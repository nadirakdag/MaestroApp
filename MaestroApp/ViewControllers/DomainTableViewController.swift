//
//  DomainTableViewController.swift
//  MaestroPanel
//

import UIKit



class DomainTableViewController: UITableViewController {
    
    var DomainList : NSMutableArray = []
    var maestro: DomainManager = DomainManager()
    var StatusImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadDomains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDomains()
    }
    
    func loadDomains(){
        self.present(AlertViewController.getUIAlertLoding("Domainler Yükleniyor"), animated: true, completion: nil)
        maestro.getDomainList{ result in
            self.DomainList = result
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
        return DomainList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DomainCell", for: indexPath) as! DomainListTableViewCell
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        
        var imageForStatus : UIImage
        
        if domain.Status == 0 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus

        cell.LblDomainName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblDomainName.text = domain.Name
        cell.LblDomainName.font = UIFont(name: "HelveticaNeue", size: 18)
        
        cell.lblYetkili.text = "Yetkili : "
        cell.lblYetkili.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        cell.LblOwnerName.text = domain.OwnerName
        cell.LblOwnerName.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.LblExperationDate.text = dateFormatter.string(from: domain.ExpirationDate as Date)
        cell.LblExperationDate.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        cell.lblSonlanmaTarihi.text = "Sonlanma Tarihi : "
        cell.lblSonlanmaTarihi.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Sil", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            

            let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
            self.present(AlertViewController.getUIAlertLoding("\(domain.Name!) siliniyor"), animated: true, completion: nil)
            
            maestro.deleteDomain(domain.Name!){
                result in
                self.DomainList.remove(domain)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    
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
        
        
        if let serverCell = sender as? DomainListTableViewCell{
            let domainDetailView = segue.destination as! DomainDetailTableViewController
            let indexPath = self.tableView.indexPath(for: serverCell)
            let domainModel : DomainListItemModel = self.DomainList[((indexPath as NSIndexPath?)?.row)!] as! DomainListItemModel
            
            domainDetailView.dname = domainModel.Name
        }
      
     }
    
    
}
