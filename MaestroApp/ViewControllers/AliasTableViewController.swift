import UIKit

class AliasTableViewController: UITableViewController {
    
    var aliasManager:AliasManager = AliasManager()
    var aliasList:NSMutableArray = []
    var alias:AliasListItemModel?
    var dname:String = ""
    
    var alert : UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem  = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(AddAlias(sender:))
        )
        
        loadAliases()
    }

    func loadAliases() {
        alert = AlertViewController.getUIAlertLoding("LoadingAliases")
        self.present(alert!, animated: true, completion: nil)
        
        aliasManager.getAliasList(dname, completion: {result in
            self.aliasList = result
            self.tableView.reloadData()
            
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            if result.count == 0
            {
                let info : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                info.text = NSLocalizedString("NoAlias", comment: "")
                info.textColor = UIColor.black
                info.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = info
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            
            self.dismiss(animated: false, completion: nil)
        }, errcompletion: handleError)
    }
    
    
    func handleError(message: String){
        alert?.dismiss(animated: true, completion: nil)
        print(message);
    }
    
    func AddAlias(sender: UIBarButtonItem){
        
        let title : String = NSLocalizedString("AddAlias", comment: "")
        let message : String = NSLocalizedString("AddAliasMessage", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Alias"
        }
        
        let addActionTitle : String = NSLocalizedString("Add", comment: "")
        alert.addAction(UIAlertAction(title: addActionTitle, style: .default, handler: { [weak alert] (_) in
            let alias = alert?.textFields![0].text
            
            if alias == nil || alias == "" {
                self.present(AlertViewController.getUIAlertInfo("EmptyAlias"), animated: true, completion: nil)
            }
            else {
                self.present(AlertViewController.getUIAlertLoding("AddingNewAlias"), animated: true, completion: nil)
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
        
        let cancelActionTitle : String = NSLocalizedString("Cancel", comment: "")
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aliasList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aliasCell", for: indexPath) as! AliasListTableViewCell
        
        let alias = aliasList[(indexPath as NSIndexPath).row] as! AliasListItemModel
            
        cell.LblName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblName.text = alias.Name
        return cell
    }
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteActionButton = NSLocalizedString("Delete", comment: "")
        let deleteButton = UITableViewRowAction(style: .default, title: deleteActionButton, handler: { (action, indexPath) in
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
            
            let alias = aliasList[(indexPath as NSIndexPath).row] as! AliasListItemModel
            alert = AlertViewController.getUIAlertLoding("DeletingAlias")
            self.present(alert!, animated: true, completion: nil)
            
            aliasManager.deleteAlias(dname, alias: alias.Name!){
                result in
                self.aliasList.remove(alias)
                self.alert?.dismiss(animated: false, completion: nil)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}
