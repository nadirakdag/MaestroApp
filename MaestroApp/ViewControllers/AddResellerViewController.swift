import UIKit

class AddResellerViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPlanAlas: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtMailAddress: UITextField!
    @IBOutlet weak var txtOrganization: UITextField!
    
    let resellerManager : ResellerManager = ResellerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.present(AlertViewController.getUIAlertLoding("AddingNewResellerAccount"), animated: true, completion: nil)
        resellerManager.createReseller(username: txtUserName.text!, password: txtPassword.text!, planAlias: txtPlanAlas.text!, firstName: txtFirstName.text!, lastName: txtLastName.text!, mailAddress: txtMailAddress.text!, organization: txtOrganization.text!, completion: handleAddCompletion)
    }
    
    func handleAddCompletion(_ result: OperationResult){
        print("result geldi")
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
