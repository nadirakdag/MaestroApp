import UIKit

class ResellerChangePasswordViewController: UIViewController {

    var userName: String = ""
    let resellerManager : ResellerManager = ResellerManager()
    var alert : UIAlertController? = nil
    
    @IBOutlet weak var txtResellerPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changePasswordHandler(_ result: OperationResult){
        if result.Code == -1 {
            alert?.dismiss(animated: true, completion: nil)
            self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
        }
        else {
            alert?.dismiss(animated: true, completion: nil)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        alert = AlertViewController.getUIAlertLoding("ChangeResellerPassword")
        self.present(alert!, animated: true, completion: nil)
        
        resellerManager.changePassword(userName, newPass: txtResellerPassword.text!, completion: changePasswordHandler)
    }

}
