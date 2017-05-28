import UIKit

class ChangeDomainPasswordViewController: UIViewController {

    var dname : String?
    var domainManager : DomainManager = DomainManager()
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBAction func saveNewPassword(_ sender: AnyObject) {
        self.present(AlertViewController.getUIAlertLoding("ChangeDomainPassword"), animated: true, completion: nil)
        domainManager.changePassword(dname!, newPass: txtNewPassword.text!, completion: changePasswordHandler)
    }
    
    func changePasswordHandler(_ result: OperationResult){
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
