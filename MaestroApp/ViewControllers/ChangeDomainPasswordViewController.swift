//
//  ChangeDomainPasswordViewController.swift
//  MaestroPanel
//

import UIKit

class ChangeDomainPasswordViewController: UIViewController {

    var dname : String?
    var domainManager : DomainManager = DomainManager()
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBAction func saveNewPassword(_ sender: AnyObject) {
        self.present(AlertViewController.getUIAlertLoding("Domain Parolası Değiştiriliyor"), animated: true, completion: nil)
        domainManager.changePassword(dname!, newPass: txtNewPassword.text!, completion: changePasswordHandler)
    }
    
    func changePasswordHandler(_ result: OperationResult){
        if result.Code == -1 {
            self.dismiss(animated: false, completion: nil)
            self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
