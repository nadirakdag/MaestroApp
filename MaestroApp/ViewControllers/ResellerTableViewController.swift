import UIKit

class ResellerTableViewController: UITableViewController {
    
    
    var resellerList : NSMutableArray=[]
    var maestro : ResellerManager = ResellerManager()
    var StatusImage: UIImageView?
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            loadResellers()
        } else {
            let alertTitle : String = NSLocalizedString("NetworkInfoTitle", comment: "")
            let alertMessage : String = NSLocalizedString("NetworkInfoMessage", comment: "")
            let alert = UIAlertController(title: alertTitle, message: alertMessage ,  preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func loadResellers(){
        alert = AlertViewController.getUIAlertLoding("LoadingResellers")
        present(alert!, animated: true, completion: nil)
        maestro.getResellerList({result in
            self.resellerList = result
            self.tableView.reloadData()
            self.alert?.dismiss(animated: true, completion: nil)
        }, errcompletion: handleError)
        
    }
    
    
    func handleError(message: String){
        alert?.dismiss(animated: true, completion: { _ in
            let infoAlert = AlertViewController.getUIAlertInfo(message)
            self.present(infoAlert, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resellerList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resellerCell", for: indexPath) as! ResellerListTableViewCell
        
        let reseller = resellerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        
        
        var imageForStatus : UIImage
        
       if reseller.Status == 1 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
 
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblNameLastname.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblNameLastname.text = ("\(reseller.FirstName!) \(reseller.LastName!)")
        
        cell.LblUsername.text = reseller.Username
        cell.LblUsername.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.LblExpirationDate.text = dateFormatter.string(from: reseller.ExpirationDate as Date)
        cell.LblExpirationDate.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteActionTitle : String = NSLocalizedString("Delete", comment: "")
        let deleteButton = UITableViewRowAction(style: .default, title: deleteActionTitle, handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.red
        
        var statusChangeButtonTitle : String
        var statusChangeButtonColor : UIColor
        
        let reseller = resellerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        if reseller.Status != 1 {
            statusChangeButtonTitle = NSLocalizedString("Start", comment: "")
            statusChangeButtonColor = UIColor.green
        }
        else{
            statusChangeButtonTitle = NSLocalizedString("Stop", comment: "")
            statusChangeButtonColor = UIColor.blue
        }
        
        let statusButton = UITableViewRowAction(style: .default, title: statusChangeButtonTitle, handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .none,
                forRowAt: indexPath
            )
            
            return
        })
        
        statusButton.backgroundColor = statusChangeButtonColor
        return [deleteButton,statusButton]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let reseller = resellerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        
        if editingStyle == .delete {
            
            self.present(AlertViewController.getUIAlertLoding("DeleteingReseller"), animated: true, completion: nil)
            
            maestro.deleteReseller(reseller.Username!){
                result in
                self.resellerList.remove(reseller)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .none {
            
            self.present(AlertViewController.getUIAlertLoding("ChangingStatusOfReseller"), animated: true, completion: nil)
            
            if reseller.Status == 1 {
                maestro.stopReseller(reseller.Username!){
                    result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadResellers()
                }
            }
            else {
                maestro.startReseller(reseller.Username!){
                    result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadResellers()
                }
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (sender as? ResellerListTableViewCell) != nil {
            
            print(resellerList.count)
            let username: String = (sender as! ResellerListTableViewCell).LblUsername.text!
            let predicate : NSPredicate = NSPredicate(format: "Username = %@", username)
            resellerList.filter(using: predicate)
            let result : ResellerListItemModel = resellerList[0] as! ResellerListItemModel
            print(resellerList.count)
            let resellerDetailView = segue.destination as! ResellerDetailTableViewController
            resellerDetailView.reseller = result
        }
    }

}
