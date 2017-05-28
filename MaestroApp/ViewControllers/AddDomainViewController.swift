import UIKit

class AddDomainViewController: UIViewController {
    
    @IBOutlet weak var LblDname: UITextField!
    @IBOutlet weak var LblPassword: UITextField!
    @IBOutlet weak var LblFtpUserName: UITextField!
    @IBOutlet weak var LblName: UITextField!
    @IBOutlet weak var LblSurname: UITextField!
    @IBOutlet weak var LblMail: UITextField!
    
    let domainManager : DomainManager = DomainManager()
    
    var isReseller : Bool = false
    var resellerName : String?
    
    @IBAction func saveDomain(_ sender: UIBarButtonItem) {
        self.present(AlertViewController.getUIAlertLoding("AddingNewDomain"), animated: true, completion:nil)
        domainManager.addDomain(LblDname.text!, username: LblFtpUserName.text!, password: LblPassword.text!, activiteDomainUser: true, firstName: LblName.text!, lastName: LblSurname.text!, email: LblMail.text!, isReseller: isReseller, resellerName: resellerName!, completion: handleAddDomainCompletion)
    }
    
    func handleAddDomainCompletion(_ result: OperationResult){
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
