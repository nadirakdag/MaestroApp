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
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView")
        present(controller, animated: true, completion: nil)
    }    
    
    func ReciveData(message: String) {
        txtApiKey.text = message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! QrScannerViewController
        nav.dataDelivery = self
    }
    

}
