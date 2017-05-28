import UIKit

class FTPUserPasswordChangeViewController: UIViewController {

    var dname : String?
    var accountName : String?
    var ftpManager : FtpManager = FtpManager()
    
    @IBOutlet weak var TxtNewPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeUserPassword(_ sender: Any) {
        self.present(AlertViewController.getUIAlertLoding("ChangingFTPUserPassword"), animated: true, completion: nil)
        ftpManager.ChangePasswordOfFtpAccount(dname!, account: accountName!,password: TxtNewPassword.text!, completion: changePasswordHandler)
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

}
