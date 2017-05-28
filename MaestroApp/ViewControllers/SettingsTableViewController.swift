import UIKit

class SettingsTableViewController: UITableViewController {

    let preferences = UserDefaults.standard
    let apiKeyObjectKey : String = "apiKey"
    let apiUrlObjectKey : String = "apiUrl"

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "apiInfoSegue" {
            let nav = segue.destination as! UINavigationController
            let addEventViewController = nav.topViewController as! ApiInfoViewController
            addEventViewController.isRoot = false
        }
    }
}
