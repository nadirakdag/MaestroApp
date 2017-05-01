//
//  SubdomainTableViewController.swift
//  MaestroPanel
//

import UIKit

class SubdomainTableViewController: UITableViewController {
    
    var subdomainManager:SubdomainManager = SubdomainManager()
    var subdomainList:NSMutableArray = []
    var subdomain:SubdomainListItemModel?
    var dname:String=""
    
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)

    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        self.navigationItem.title = "Subdomain Yönetimi"
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        subdomainManager.getSubdomainList(dname, completion: {result in
            self.subdomainList = result
            self.tableView.reloadData()
            
            self.dismiss(animated: false, completion: nil)
            
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = "Henüz kayıt bulunmuyor."
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }

        } )
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
        return subdomainList.count


    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subdomainCell", for: indexPath) as! SubdomainListTableViewCell
        
        let subdomain = subdomainList[(indexPath as NSIndexPath).row] as! SubdomainListItemModel
        
        
        cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblName.text = subdomain.Name! + "." + self.dname
        cell.LblName.font = UIFont(name: "HelveticaNeue", size: 18)

        cell.LblFtpKullanici.text = "FTP Kullanıcısı : "
        cell.LblFtpKullanici.font = UIFont(name: "HelveticaNeue", size: 11)

        
        cell.LblFtpUser.text = subdomain.FtpUser
        cell.LblFtpUser.font = UIFont(name: "HelveticaNeue-light", size: 11)

        cell.LblSupport.text = subdomain.Support!
        
        // Configure the cell...

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
            
            let subdomain = subdomainList[(indexPath as NSIndexPath).row] as! SubdomainListItemModel
            self.present(AlertViewController.getUIAlertLoding("Subdomain siliniyor"), animated: true, completion: nil)
            
            subdomainManager.deleteSubdomain(dname, subdomain: subdomain.Name!){
                result in
                self.subdomainList.remove(subdomain)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let addSubdomainViewController = segue.destination as! AddSubdomainViewController
        addSubdomainViewController.dname = dname
    }
}


