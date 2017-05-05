//
//  AddDbUserViewController.swift
//  MaestroApp
//
//  Created by Nadir on 05/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import UIKit

class AddDbUserViewController: UIViewController {

    var dname : String?
    var dbType : String?
    var dbName : String?

    @IBOutlet weak var txtDomainName: UITextField!
    @IBOutlet weak var txtDbName: UITextField!
    @IBOutlet weak var segmentDbType: UISegmentedControl!
    @IBOutlet weak var txtDbUserName: UITextField!
    @IBOutlet weak var txtDbUserPassword: UITextField!
    
    let dbManager : DatabaseManager = DatabaseManager()
    
    
    @IBAction func addDbUser(_ sender: Any) {
        self.present(AlertViewController.getUIAlertLoding("Yeni Veri Tabanı Kullanıcısı ekleniyor..."), animated: true, completion: nil)
        
        dbManager.addDatabaseUser(dname!, dbType: dbType!, database: dbName!, userName: txtDbUserName.text!, password: txtDbUserPassword.text!, completion: handleAddCompletion)
    }
    
    func handleAddCompletion(result: OperationResult){
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

        txtDomainName.text = dname
        txtDbName.text = dbName
        
        if dbType == "mssql"{
            segmentDbType.selectedSegmentIndex = 0
        }
        else {
            segmentDbType.selectedSegmentIndex = 1
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
