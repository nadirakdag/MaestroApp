//
//  DatabaseTableViewController.swift
//  MaestroPanel
//

import UIKit

class DatabaseTableViewController: UITableViewController {

    var databaseManager:DatabaseManager = DatabaseManager()
    var databaseList:NSMutableArray = []
    var dname:String = ""
    var DatabaseImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Veri Tabanı Yönetimi"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadDatabaseRecors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDatabaseRecors()
    }
    
    func loadDatabaseRecors(){
        present(AlertViewController.getUIAlertLoding("Veri Tabanları Yükleniyor"), animated: true, completion: nil)
        databaseManager.getDatabaseList(dname, completion: {result in
            self.databaseList = result
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = "Henüz bir veritabanı ekli değil."
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
            
        })
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


        cell.LblLimit.text = "Limit : "
        cell.LblLimit.font = UIFont(name: "HelveticaNeue", size: 11)
        
        if (String(describing: database.DiskQuota) == "-1")
        {
            cell.LblDiskQuota.text = "Sınırsız"
            cell.LblDiskQuota.font = UIFont(name: "HelveticaNeue-light", size: 11)

        }
        else
        {
            cell.LblDiskQuota.text = String(database.DiskQuota!) + " MB"
            cell.LblDiskQuota.font = UIFont(name: "HelveticaNeue-light", size: 11)
        }
        

        cell.LblBoyut.text = "Boyut : "
        cell.LblBoyut.font = UIFont(name: "HelveticaNeue", size: 11)

        cell.LblDiskUsage.text = String(database.DiskUsage!) + " MB"
        cell.LblDiskUsage.font = UIFont(name: "HelveticaNeue-light", size: 11)


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
    override func tableView(_ tableView: UITableView, commit editingStyle:
        
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let database = databaseList[(indexPath as NSIndexPath).row] as! DatabaseListItemModel
            self.present(AlertViewController.getUIAlertLoding("Veri tabanı siliniyor..."), animated: true, completion: nil)

            
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
        let addDatabaseViewController = segue.destination as! AddDatabaseViewController
        addDatabaseViewController.dname = dname
    }
    

}
