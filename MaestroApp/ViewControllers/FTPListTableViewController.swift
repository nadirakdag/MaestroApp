//
//  FTPListTableViewController.swift
//  MaestroPanel
//

import UIKit

class FTPListTableViewController: UITableViewController {

    var dname : String?
    let ftpManager : FtpManager = FtpManager()
    var StatusImage: UIImageView?
    
    var ftpUsers : NSMutableArray = []
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        self.navigationItem.title = "FTP Yönetimi"
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
        
        ftpManager.getFtpList(dname!, completion: { result in
            self.ftpUsers = result
            self.tableView.reloadData()
            self.navigationItem.title = "FTP Yönetimi"
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            cell.LblReadOnly.text = "Okuma,Yazma"
            cell.LblReadOnly.font = UIFont(name: "HelveticaNeue-light", size: 11)
        } else {
            cell.LblReadOnly.text = "Okuma"
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let ftpUser = ftpUsers[(indexPath as NSIndexPath).row] as! FtpListItemModel
            self.present(AlertViewController.getUIAlertLoding("FTP hesabı siliniyor..."), animated: true, completion: nil)

            ftpManager.deleteFtpAccount(dname!, account: ftpUser.UserName!){ result in
                self.ftpUsers.remove(ftpUser)
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
