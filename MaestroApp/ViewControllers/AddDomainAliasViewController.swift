//
//  AddDomainAliasViewController.swift
//  MaestroPanel
//

import UIKit

class AddDomainAliasViewController: UIViewController {

    
    var dname : String?
    let aliasManager : AliasManager = AliasManager()
    
    @IBOutlet weak var TxtDomainAlias: UITextField!
    
    @IBAction func addDomainAlias(_ sender: AnyObject) {
        self.present(AlertViewController.getUIAlertLoding("Alias Ekleniyor"), animated: true, completion: nil)
        aliasManager.addAlias(dname!, alias: TxtDomainAlias.text!){
         result in
            if result.Code == -1 {
                self.dismiss(animated: false, completion: nil)
                self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
                
            }
            else {
                self.dismiss(animated: false, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
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
