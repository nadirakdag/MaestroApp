//
//  AddFtpUserViewController.swift
//  MaestroPanel
//

import UIKit

class AddFtpUserViewController: UIViewController {

    var dname : String?
    var ftpManager: FtpManager = FtpManager()
    
    @IBOutlet weak var TxtFtpUsername: UITextField!
    @IBOutlet weak var TxtFtpPassword: UITextField!
    @IBOutlet weak var SwchReadOnly: UISwitch!
    
    
    @IBAction func saveFtpUser(_ sender: AnyObject) {
        
        let readOnly : Bool = SwchReadOnly.isOn
        
        self.present(AlertViewController.getUIAlertLoding("Yeni FTP kullanıcısı ekleniyor..."), animated: true, completion: nil)
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
