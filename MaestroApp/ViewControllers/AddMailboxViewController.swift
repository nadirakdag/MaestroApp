import UIKit

class AddMailboxViewController: UIViewController {

    var dname: String?
    let mailboxManager : MailManager = MailManager()
    
    @IBOutlet weak var TxtMailbox: UITextField!
    @IBOutlet weak var TxtMailboxPassword: UITextField!
    @IBOutlet weak var TxtMailboxQuota: UITextField!
    
    @IBAction func saveMailbox(_ sender: AnyObject) {
      self.present(AlertViewController.getUIAlertLoding("AddingNewMailbox"), animated: true, completion: nil)  
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
