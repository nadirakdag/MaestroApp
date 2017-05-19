//
//  DomainTableViewController.swift
//  MaestroPanel
//

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
            print("network is OK")
            loadDomains()
        } else {
            print("network is not OK")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.",  preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadDomains(){
        
        alert = AlertViewController.getUIAlertLoding("Domainler Yükleniyor")
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
        // Dispose of any resources that can be recreated.
    }
    
    
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
        } else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblDomainName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblDomainName.text = domain.Name
        cell.LblDomainName.font = UIFont(name: "HelveticaNeue", size: 18)
        
        cell.LblOwnerName.text = domain.OwnerName
        cell.LblOwnerName.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.LblExperationDate.text = dateFormatter.string(from: domain.ExpirationDate as Date)
        cell.LblExperationDate.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
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
        
        var statusChangeButtonTitle : String
        var statusChangeButtonColor : UIColor
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        if domain.Status! == 1 {
            statusChangeButtonTitle = "Başlat"
            statusChangeButtonColor = UIColor.green
        }
        else{
            statusChangeButtonTitle="Durdur"
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
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let domain = DomainList[(indexPath as NSIndexPath).row] as! DomainListItemModel
        
        if editingStyle == .delete {
            
            self.present(AlertViewController.getUIAlertLoding("\(domain.Name!) siliniyor"), animated: true, completion: nil)
            
            maestro.deleteDomain(isReseller,userName: resellerName,dname: domain.Name!){
                result in
                self.DomainList.remove(domain)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .none {
            
            self.present(AlertViewController.getUIAlertLoding("\(domain.Name!) durumu değiştiriliyor"), animated: true, completion: nil)
            
            if domain.Status! == 0 {
                maestro.stopDomain(domain.Name!){
                    result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadDomains()
                }
            }
            else {
                maestro.startDomain(domain.Name!){
                    result in
                    self.dismiss(animated: false, completion: nil)
                    self.loadDomains()
                }
            }
            
           
        }
    }
    
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
