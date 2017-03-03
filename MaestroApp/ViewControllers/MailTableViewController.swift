//
//  MailTableViewController.swift
//  MaestroPanel
//

import UIKit

class MailTableViewController: UITableViewController {

    var dname : String?
    let mailManager : MailManager = MailManager()
    var mail:MailListModel?
    var StatusImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        self.navigationItem.title = "Mailbox Yönetimi"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadMailBoxes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMailBoxes()
    }
    
    func loadMailBoxes() {
        self.present(AlertViewController.getUIAlertLoding("Mailboxlar yükleniyor..."), animated: true, completion: nil)
        mailManager.getMailList(dname!){ result in
            self.mail = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            if self.mail?.Accounts.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = "Henüz bir kayıt bulunmuyor."
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }

            
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
        if mail != nil {
            return mail!.Accounts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mailIdentifier", for: indexPath) as! MailListTableViewCell

        let acc : AccountListItem = (mail?.Accounts[(indexPath as NSIndexPath).row])! as! AccountListItem
        
        var imageForStatus : UIImage
        
        if acc.Status == 1 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus
        
        cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblName.text = acc.Name! + "@" + self.dname!
        cell.LblName.font = UIFont(name: "HelveticaNeue", size: 18)

        cell.LblKota.text = "Kota : "
        cell.LblKota.font = UIFont(name: "HelveticaNeue", size: 11)
        if acc.Quota == -1
        {
            cell.LblQuota.text = "Sınırsız"
            cell.LblQuota.font = UIFont(name: "HelveticaNeue-light", size: 11)
        }
        else
        {
            
            cell.LblQuota.text = String(acc.Quota!) + " MB"
            cell.LblQuota.font = UIFont(name: "HelveticaNeue-light", size: 11)
        
        }
        
        cell.LblKullanilan.text = "Kullanılan : "
        cell.LblKullanilan.font = UIFont(name: "HelveticaNeue", size: 11)
        cell.LblUsage.text = String(acc.Usage!) + " MB"
        cell.LblUsage.font = UIFont(name: "HelveticaNeue-light", size: 11)

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
            
            
            self.present(AlertViewController.getUIAlertLoding("Mailbox siliniyor"), animated: true, completion: nil)
            
            let mailbox = mail?.Accounts[(indexPath as NSIndexPath).row] as! AccountListItem
            
            mailManager.deleteMailbox(dname!, account: mailbox.Name!){
                result in
                self.mail?.Accounts.remove(mailbox)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.dismiss(animated: false, completion: nil)
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
        let addMailboxViewController = segue.destination  as! AddMailboxViewController
        addMailboxViewController.dname=dname!
    }
    

}
