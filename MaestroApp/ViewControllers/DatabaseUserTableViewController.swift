import UIKit

class DatabaseUserTableViewController: UITableViewController {
    
    var dname : String?
    var dbType : String?
    var dbName : String?
    
    var dbUserList : NSMutableArray = []

    var databaseManager : DatabaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dbUserList.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = (dbUserList[(indexPath as NSIndexPath).row] as! DbUserListItemModel).Username!
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
            let dbUser = dbUserList[(indexPath as NSIndexPath).row] as! DbUserListItemModel
            self.present(AlertViewController.getUIAlertLoding("DeletingDatabaseUser"), animated: true, completion: nil)
            
            databaseManager.deleteDatabaseUser(dname!, dbType: dbType!, database: dbName!, userName: dbUser.Username!){
                result in
                self.dbUserList.remove(dbUser)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dbUserListView = segue.destination as! AddDbUserViewController
        dbUserListView.dname = dname
        dbUserListView.dbType = dbType
        dbUserListView.dbName = dbName
    }
    
}
