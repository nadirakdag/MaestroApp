import UIKit

class MailTableViewController: UITableViewController {

    var dname : String?
    let mailManager : MailManager = MailManager()
    var mail:MailListModel?
    var StatusImage: UIImageView?
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMailBoxes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMailBoxes()
    }
    
    
    func loadMailBoxes() {
        alert = AlertViewController.getUIAlertLoding("LoadingMailboxes")
        self.present(alert!, animated: true, completion: nil)
        
        mailManager.getMailList(dname!, completion: { result in
            self.mail = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            
            if self.mail?.Accounts.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = NSLocalizedString("NoMailbox", comment: "")
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            else {
                if self.tableView.backgroundView != nil {
                    self.tableView.backgroundView = nil
                }
            }
        }, errcompletion: handleError)
    }
    
    func handleError(message: String){
        alert?.dismiss(animated: true, completion: nil)
        print(message);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        if acc.Quota == -1 {
            cell.LblQuota.text = NSLocalizedString("Unlimited", comment: "")
        } else {
            cell.LblQuota.text = String(acc.Quota!) + " MB"
        }
        
        cell.LblUsage.text = String(acc.Usage!) + " MB"
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
        return [deleteButton]
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            self.present(AlertViewController.getUIAlertLoding("DeletingMailbox"), animated: true, completion: nil)
            
            let mailbox = mail?.Accounts[(indexPath as NSIndexPath).row] as! AccountListItem
            
            mailManager.deleteMailbox(dname!, account: mailbox.Name!){
                result in
                self.mail?.Accounts.remove(mailbox)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addMailboxViewController = segue.destination  as! AddMailboxViewController
        addMailboxViewController.dname=dname!
    }
}
