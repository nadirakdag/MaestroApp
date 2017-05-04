//
//  AddDomainViewController.swift
//  MaestroPanel
//

import UIKit

class AddDomainViewController: UIViewController {
    
    @IBOutlet weak var LblDname: UITextField!
    @IBOutlet weak var LblPassword: UITextField!
    @IBOutlet weak var LblFtpUserName: UITextField!
    @IBOutlet weak var LblName: UITextField!
    @IBOutlet weak var LblSurname: UITextField!
    @IBOutlet weak var LblMail: UITextField!
    
    let domainManager : DomainManager = DomainManager()
    
    @IBAction func saveDomain(_ sender: UIBarButtonItem) {
        self.present(AlertViewController.getUIAlertLoding("Yeni Domain Oluşturuluyor"), animated: true, completion:nil)
        domainManager.addDomain(LblDname.text!, username: LblFtpUserName.text!, password: LblPassword.text!, activiteDomainUser: true, firstName: LblName.text!, lastName: LblSurname.text!, email: LblMail.text!, completion: handleAddDomainCompletion)
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
