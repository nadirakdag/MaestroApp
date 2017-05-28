import UIKit

class AddDatabaseViewController: UIViewController {

    var dname : String?
    let databaseManager : DatabaseManager = DatabaseManager()
    
    @IBOutlet weak var TxtDatabaseName: UITextField!
    @IBOutlet weak var TxtDatabaseQuota: UITextField!
    @IBOutlet weak var TxtDatabaseUserName: UITextField!
    @IBOutlet weak var TxtDatabaseUserPass: UITextField!
    @IBOutlet weak var BtnDbType: UISegmentedControl!
    
    
    @IBAction func saveDatabase(_ sender: AnyObject) {
       
        self.present(AlertViewController.getUIAlertLoding("AddingNewDatabase"), animated: true, completion: nil)
        
        let dbtype : String
        if (BtnDbType.selectedSegmentIndex == 0){
            dbtype = "mssql"
        } else {
            dbtype = "mysql"
        }
        
        
        databaseManager.createDatabase(dname!, dbType: dbtype, database: TxtDatabaseName.text!, userName: TxtDatabaseUserName.text!, password: TxtDatabaseUserPass.text!, quota: Int(TxtDatabaseQuota.text!)!, completion: handleAddCompletion);
    }
    
    func handleAddCompletion(_ result: OperationResult){
        if result.Code == -1 {
            self.dismiss(animated: false, completion: nil)
            self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
