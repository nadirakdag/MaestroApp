import UIKit

class AddDbUserViewController: UIViewController {

    var dname : String?
    var dbType : String?
    var dbName : String?

    @IBOutlet weak var txtDomainName: UITextField!
    @IBOutlet weak var txtDbName: UITextField!
    @IBOutlet weak var segmentDbType: UISegmentedControl!
    @IBOutlet weak var txtDbUserName: UITextField!
    @IBOutlet weak var txtDbUserPassword: UITextField!
    
    let dbManager : DatabaseManager = DatabaseManager()
    
    
    @IBAction func addDbUser(_ sender: Any) {
        self.present(AlertViewController.getUIAlertLoding("AddingNewDatabaseUser"), animated: true, completion: nil)
        
        dbManager.addDatabaseUser(dname!, dbType: dbType!, database: dbName!, userName: txtDbUserName.text!, password: txtDbUserPassword.text!, completion: handleAddCompletion)
    }
    
    func handleAddCompletion(result: OperationResult){
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

        txtDomainName.text = dname
        txtDbName.text = dbName
        
        if dbType == "mssql"{
            segmentDbType.selectedSegmentIndex = 0
        }
        else {
            segmentDbType.selectedSegmentIndex = 1
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
