import UIKit

class SubdomainTableViewController: UITableViewController {
    
    var subdomainManager:SubdomainManager = SubdomainManager()
    var subdomainList:NSMutableArray = []
    var subdomain:SubdomainListItemModel?
    var dname:String=""
    
    
    let alert = AlertViewController.getUIAlertLoding("LoadingSubdomains")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height
        present(alert, animated: true, completion: nil)
        
        subdomainManager.getSubdomainList(dname, completion: {result in
            self.subdomainList = result
            self.tableView.reloadData()
            
            self.dismiss(animated: false, completion: nil)
            
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = NSLocalizedString("NoSubdomain", comment: "")
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }

        }, errcompletion: handleError )
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
        return subdomainList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subdomainCell", for: indexPath) as! SubdomainListTableViewCell
        
        let subdomain = subdomainList[(indexPath as NSIndexPath).row] as! SubdomainListItemModel
        
        cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblName.text = subdomain.Name! + "." + self.dname
        cell.LblName.font = UIFont(name: "HelveticaNeue", size: 18)

        cell.LblFtpUser.text = subdomain.FtpUser
        cell.LblFtpUser.font = UIFont(name: "HelveticaNeue-light", size: 11)

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
            
            let subdomain = subdomainList[(indexPath as NSIndexPath).row] as! SubdomainListItemModel
            self.present(AlertViewController.getUIAlertLoding("DeletingSubdomain"), animated: true, completion: nil)
            
            subdomainManager.deleteSubdomain(dname, subdomain: subdomain.Name!){
                result in
                self.subdomainList.remove(subdomain)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addSubdomainViewController = segue.destination as! AddSubdomainViewController
        addSubdomainViewController.dname = dname
    }
}


