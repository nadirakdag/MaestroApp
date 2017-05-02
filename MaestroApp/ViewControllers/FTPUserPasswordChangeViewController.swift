//
//  FTPUserPasswordChangeViewController.swift
//  MaestroApp
//
//  Created by Nadir on 01/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import UIKit

class FTPUserPasswordChangeViewController: UIViewController {

    var dname : String?
    var accountName : String?
    var ftpManager : FtpManager = FtpManager()
    
    @IBOutlet weak var TxtNewPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeUserPassword(_ sender: Any) {
        self.present(AlertViewController.getUIAlertLoding("FTP Kullanıcı Parolası Değiştiriliyor"), animated: true, completion: nil)
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
