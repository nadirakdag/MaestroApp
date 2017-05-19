//
//  ApiInfoViewController.swift
//  MaestroApp
//
//  Created by Nadir on 19/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import UIKit

class ApiInfoViewController: UIViewController, DataDelivery {

    @IBOutlet weak var txtApiHost: UITextField!
    @IBOutlet weak var txtApiKey: UITextField!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    let preferences = UserDefaults.standard
    let apiKeyObjectKey : String = "apiKey"
    let apiUrlObjectKey : String = "apiUrl"
    
    var isRoot : Bool = true
    
    var tabGesture : UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isRoot) {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        tabGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTab(sender:)))
        tabGesture?.cancelsTouchesInView = false;
        view.addGestureRecognizer(tabGesture!)
        
        if preferences.object(forKey: apiKeyObjectKey) != nil{
            txtApiKey.text = preferences.string(forKey: apiKeyObjectKey)!
        }
        
        if preferences.object(forKey: apiUrlObjectKey) != nil {
            txtApiHost.text = preferences.string(forKey: apiUrlObjectKey)!
        }
    }
    
    func handleTab(sender : UIGestureRecognizer)  {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSave(_ sender: Any) {
        preferences.set(txtApiKey.text, forKey: apiKeyObjectKey)
        preferences.set(txtApiHost.text, forKey: apiUrlObjectKey)
    }    
    
    func ReciveData(message: String) {
        txtApiKey.text = message
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nav = segue.destination as! QrScannerViewController
        nav.dataDelivery = self
    }
    

}
