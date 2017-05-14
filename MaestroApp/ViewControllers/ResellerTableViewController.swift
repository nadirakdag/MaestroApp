//
//  ResellerTableViewController.swift
//  MaestroPanel
//

import UIKit

class ResellerTableViewController: UITableViewController {
    
    
    var resellerList : NSMutableArray=[]
    var maestro : ResellerManager = ResellerManager()
    var StatusImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadResellers()
    }
    
    func loadResellers(){
        present(AlertViewController.getUIAlertLoding("Bayiler yükleniyor"), animated: true, completion: nil)
        maestro.getResellerList{result in
            self.resellerList = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            
        }
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
        
        let reseller = resellerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        if reseller.Status != 1 {
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let reseller = resellerList[(indexPath as NSIndexPath).row] as! ResellerListItemModel
        
        if editingStyle == .delete {
            
            self.present(AlertViewController.getUIAlertLoding("\(reseller.FirstName!) \(reseller.LastName!) siliniyor"), animated: true, completion: nil)
            
            maestro.deleteReseller(reseller.Username!){
                result in
                self.resellerList.remove(reseller)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .none {
            
            self.present(AlertViewController.getUIAlertLoding("\(reseller.FirstName!) \(reseller.LastName!) durumu değiştiriliyor"), animated: true, completion: nil)
            
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
            
            let username: String = (sender as! ResellerListTableViewCell).LblUsername.text!
            let predicate : NSPredicate = NSPredicate(format: "Username = %@", username)
            resellerList.filter(using: predicate)
            let result : ResellerListItemModel = resellerList[0] as! ResellerListItemModel
            
            let resellerDetailView = segue.destination as! ResellerDetailTableViewController
            resellerDetailView.reseller = result
        }
//        else{
//            //let addDatabaseViewController = segue.destination as! AddResellerViewController
//        }
    }

}
