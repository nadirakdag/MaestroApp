import UIKit

class DomainTableViewController: UITableViewController {
    
    var DomainList : NSMutableArray = []
    var maestro: DomainManager = DomainManager()
    var StatusImage: UIImageView?
    var isReseller : Bool = false
    var resellerName : String = ""
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() == true {
            loadDomains()
        } else {
            let alertTitle : String = NSLocalizedString("NetworkInfoTitle", comment: "")
            let alertMessage : String = NSLocalizedString("NetworkInfoMessage", comment: "")
            let alert = UIAlertController(title: alertTitle, message: alertMessage,  preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadDomains(){
        
        alert = AlertViewController.getUIAlertLoding("LoadingDomains")
        self.present(alert!, animated: true, completion: nil)
        
        maestro.getDomainList(isReseller, resellerUserName: resellerName, completion: { result in
            self.DomainList = result
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
        return DomainList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DomainCell", for: indexPath) as! DomainListTableViewCell
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        
        var imageForStatus : UIImage
        
        if domain.Status == 0 {
            imageForStatus = UIImage(named:"working")!
        } else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblDomainName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblDomainName.text = domain.Name
        
        cell.LblOwnerName.text = domain.OwnerName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.LblExperationDate.text = dateFormatter.string(from: domain.ExpirationDate as Date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let deleteActionButton = NSLocalizedString("Delete", comment: "")
        let deleteButton = UITableViewRowAction(style: .default, title: deleteActionButton, handler: { (action, indexPath) in
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
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        if domain.Status! == 1 {
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
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        
        if editingStyle == .delete {
            
            self.present(AlertViewController.getUIAlertLoding("DeletingDomain"), animated: true, completion: nil)
            
            maestro.deleteDomain(isReseller,userName: resellerName,dname: domain.Name!){
                result in
                self.DomainList.remove(domain)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .none {
            self.present(AlertViewController.getUIAlertLoding("ChangingDomainStatus"), animated: true, completion: nil)
            
            if domain.Status! == 0 {
                maestro.stopDomain(domain.Name!){
                    result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadDomains()
                }
            }
            else {
                maestro.startDomain(domain.Name!){result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadDomains()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let serverCell = sender as? DomainListTableViewCell{
            let domainDetailView = segue.destination as! DomainDetailTableViewController
            let indexPath = self.tableView.indexPath(for: serverCell)
            let domainModel : DomainListItemModel = self.DomainList[((indexPath as NSIndexPath?)?.row)!] as! DomainListItemModel
            
            domainDetailView.dname = domainModel.Name
        }
        else {
            let addDomainView = segue.destination as! AddDomainViewController
            addDomainView.isReseller = isReseller
            addDomainView.resellerName = resellerName
        }
        
    }
    
    
}
