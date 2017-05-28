import UIKit

class AddFtpUserViewController: UIViewController {

    var dname : String?
    var ftpManager: FtpManager = FtpManager()
    
    @IBOutlet weak var TxtFtpUsername: UITextField!
    @IBOutlet weak var TxtFtpPassword: UITextField!
    @IBOutlet weak var SwchReadOnly: UISwitch!
    
    
    @IBAction func saveFtpUser(_ sender: AnyObject) {
        
        let readOnly : Bool = SwchReadOnly.isOn
        
        self.present(AlertViewController.getUIAlertLoding("AddingNewFTPUser"), animated: true, completion: nil)
        ftpManager.addFtpAccount(dname!, account: TxtFtpUsername.text!, password: TxtFtpPassword.text!, readOnly: readOnly,completion: handleAddCompletion);
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
