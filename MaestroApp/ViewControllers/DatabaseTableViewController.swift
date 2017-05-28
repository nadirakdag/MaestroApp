import UIKit

class DatabaseTableViewController: UITableViewController {

    var databaseManager:DatabaseManager = DatabaseManager()
    var databaseList:NSMutableArray = []
    var dname:String = ""
    var DatabaseImage: UIImageView?
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabaseRecors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDatabaseRecors()
    }
    
    func loadDatabaseRecors(){
        alert = AlertViewController.getUIAlertLoding("LoadingDatabaseList")
        present(alert!, animated: true, completion: nil)
        databaseManager.getDatabaseList(dname, completion: {result in
            self.databaseList = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = NSLocalizedString("NoDatabase", comment: "")
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
        return databaseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "databaseCell", for: indexPath) as! DatabaseListTableViewCell
        
        let database = databaseList[(indexPath as NSIndexPath).row] as! DatabaseListItemModel
        
        
        var DatabaseImage : UIImage
        
        if database.DbType == "mssql" {
            DatabaseImage = UIImage(named:"mssql")!
        }
        else{
            DatabaseImage = UIImage(named: "mysql")!
        }
        
        cell.LblTur.image = DatabaseImage
        
        cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblName.text = database.Name
        cell.LblName.font = UIFont(name: "HelveticaNeue", size: 18)


        
        if (String(describing: database.DiskQuota) == "-1") {
            cell.LblDiskQuota.text = NSLocalizedString("Unlimited", comment: "")
        } else {
            cell.LblDiskQuota.text = String(database.DiskQuota!) + " MB"
        }

        cell.LblDiskUsage.text = String(database.DiskUsage!) + " MB"

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
            
            let database = databaseList[(indexPath as NSIndexPath).row] as! DatabaseListItemModel
            self.present(AlertViewController.getUIAlertLoding("DeletingDatabase"), animated: true, completion: nil)
            
            let dbType : String
            
            if database.DbType == "mysql" {
                dbType="mysql"
            }else {
                dbType="mssql"
            }
            
            databaseManager.deleteDatabase(dname, database: database.Name!, dbtype: dbType){
                result in
                self.databaseList.remove(database)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (sender as? DatabaseListTableViewCell) != nil{
            
            let dbname: String = (sender as! DatabaseListTableViewCell).LblName.text!
            let predicate : NSPredicate = NSPredicate(format: "Name = %@", dbname)
            databaseList.filter(using: predicate)
            let result : DatabaseListItemModel = databaseList[0] as! DatabaseListItemModel
            
            let dbUserListView = segue.destination as! DatabaseUserTableViewController
            dbUserListView.dname = dname
            dbUserListView.dbType = result.DbType!
            dbUserListView.dbName = result.Name!
            dbUserListView.dbUserList = NSMutableArray(array: result.Users)
            
        }
        else{
            let addDatabaseViewController = segue.destination as! AddDatabaseViewController
            addDatabaseViewController.dname = dname
        }
    }
}
