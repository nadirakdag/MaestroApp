//
//  AliasTableViewController.swift
//  MaestroPanel
//

import UIKit

class AliasTableViewController: UITableViewController {
    
    var aliasManager:AliasManager = AliasManager()
    var aliasList:NSMutableArray = []
    var alias:AliasListItemModel?
    var dname:String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        self.navigationItem.title = "Alias Yönetimi"
        
       navigationItem.rightBarButtonItem  = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(AddAlias(sender:))
        )
        
        loadAliases()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAliases()
    }

    func loadAliases() {
        self.present(AlertViewController.getUIAlertLoding("Aliaslar yükleniyor..."), animated: true, completion: nil)
        
        aliasManager.getAliasList(dname) {result in
            self.aliasList = result
            self.tableView.reloadData()
            
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = " Henüz bir alias eklemiş değilsiniz."
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func AddAlias(sender: UIBarButtonItem){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Alias Ekle", message: "Eklenecek Alias Alan Adını giriniz!", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Alias"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: { [weak alert] (_) in
            let alias = alert?.textFields![0].text
            
            if alias == nil || alias == "" {
                self.present(AlertViewController.getUIAlertInfo("Alias alanı boş geçilemez!!"), animated: true, completion: nil)
            }
            else {
                self.present(AlertViewController.getUIAlertLoding("Alias Ekleniyor"), animated: true, completion: nil)
                self.aliasManager.addAlias(self.dname, alias: alias!){
                    result in
                    if result.Code == -1 {
                        self.dismiss(animated: false, completion: nil)
                        self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
                    }
                    else {
                        self.dismiss(animated: false, completion: nil)
                        self.loadAliases()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
        return aliasList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aliasCell", for: indexPath) as! AliasListTableViewCell
        
        let alias = aliasList[(indexPath as NSIndexPath).row] as! AliasListItemModel
            
            cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            cell.LblName.text = alias.Name
            cell.LblName.font = UIFont(name: "HelveticaNeue", size: 18)

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
            
            let alias = aliasList[(indexPath as NSIndexPath).row] as! AliasListItemModel
            self.present(AlertViewController.getUIAlertLoding("Alias siliniyor"), animated: true, completion: nil)
            
            aliasManager.deleteAlias(dname, alias: alias.Name!){
                result in
                self.aliasList.remove(alias)
                self.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}
