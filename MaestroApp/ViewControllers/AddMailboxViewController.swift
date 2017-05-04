//
//  AddMailboxViewController.swift
//  MaestroPanel
//

import UIKit

class AddMailboxViewController: UIViewController {

    var dname: String?
    let mailboxManager : MailManager = MailManager()
    
    @IBOutlet weak var TxtMailbox: UITextField!
    @IBOutlet weak var TxtMailboxPassword: UITextField!
    @IBOutlet weak var TxtMailboxQuota: UITextField!
    
    @IBAction func saveMailbox(_ sender: AnyObject) {
      self.present(AlertViewController.getUIAlertLoding("Yeni MailBox ekleniyor..."), animated: true, completion: nil)  
        mailboxManager.addMailbox(dname!, account: TxtMailbox.text!, password: TxtMailboxPassword.text!, quota: Int(TxtMailboxQuota.text!)!,completion:  handleAddMailboxCompletion);
    }
    
    func handleAddMailboxCompletion(_ result: OperationResult){
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
