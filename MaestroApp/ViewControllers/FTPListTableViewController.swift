import UIKit

class FTPListTableViewController: UITableViewController {

    var dname : String?
    let ftpManager : FtpManager = FtpManager()
    var StatusImage: UIImageView?
    
    var ftpUsers : NSMutableArray = []
    
    let alert = AlertViewController.getUIAlertLoding("LoadingFTPAccounts")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        present(alert, animated: true, completion: nil)
        ftpManager.getFtpList(dname!, completion: { result in
            self.ftpUsers = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        }, errcompletion: handleError)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ftpManager.getFtpList(dname!, completion: { result in
            self.ftpUsers = result
            self.tableView.reloadData()
        }, errcompletion:  handleError)
    }

    func handleError(message: String){
        alert.dismiss(animated: true, completion: nil)
        print(message);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ftpUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ftpUserCell", for: indexPath) as! FTPListTableViewCell

        let ftpUser = ftpUsers[(indexPath as NSIndexPath).row] as! FtpListItemModel
        
        var imageForStatus : UIImage
        
        if ftpUser.Status == 1 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus

        cell.LblHomePath.text = ftpUser.HomePath
        cell.LblHomePath.font = UIFont(name: "HelveticaNeue-light", size: 11)

        if (ftpUser.ReadOnly == false) {
            cell.LblReadOnly.text = NSLocalizedString("ReadAndWrite", comment: "")
            cell.LblReadOnly.font = UIFont(name: "HelveticaNeue-light", size: 11)
        } else {
            cell.LblReadOnly.text = NSLocalizedString("Read", comment: "")
            cell.LblReadOnly.font = UIFont(name: "HelveticaNeue-light", size: 11)
        }
        
        cell.LblUserName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblUserName.text = ftpUser.UserName
        cell.LblUserName.font = UIFont(name: "HelveticaNeue", size: 18)

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

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let ftpUser = ftpUsers[(indexPath as NSIndexPath).row] as! FtpListItemModel
            self.present(AlertViewController.getUIAlertLoding("FTP hesabı siliniyor..."), animated: true, completion: nil)

            ftpManager.deleteFtpAccount(dname!, account: ftpUser.UserName!){ result in
                self.ftpUsers.remove(ftpUser)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? FTPListTableViewCell) != nil{
            let ftpUserPasswordChangeView = segue.destination as! FTPUserPasswordChangeViewController
            ftpUserPasswordChangeView.dname = dname
            ftpUserPasswordChangeView.accountName = (sender as! FTPListTableViewCell).LblUserName.text!
        }
        else{
            let addFtpUserViewController = segue.destination as! AddFtpUserViewController
            addFtpUserViewController.dname = dname
        }
    }
    

}
