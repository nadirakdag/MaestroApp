import UIKit

class DomainDetailTableViewController: UITableViewController {

    var dname : String?
    var domainManager : DomainManager = DomainManager()
    
    let alert = AlertViewController.getUIAlertLoding("LoadingDomainDetail")

    
    @IBOutlet weak var LblDomainName: UILabel!
    @IBOutlet weak var LblExpirationDate: UILabel!
    @IBOutlet weak var LblOwnerName: UILabel!
    @IBOutlet weak var LblDisk: UILabel!
    @IBOutlet weak var LblEmail: UILabel!
    @IBOutlet weak var LblIpAddress: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.dname
        
        present(alert, animated: true, completion: nil)
        domainManager.getHostingDetail(dname!, completion:  { (result) in
            
            self.LblDomainName.text = result.Name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            self.LblExpirationDate.text = dateFormatter.string(from: result.ExpirationDate)
            self.LblOwnerName.text = result.OwnerName
            self.LblIpAddress.text = result.IpAddress
            self.LblDisk.text = String(result.Disk!) + "%"
            self.LblEmail.text = String(result.Email!) + NSLocalizedString("Unit", comment: "")
            self.dismiss(animated: false, completion: nil)
        }, errcompletion: handleError)
    }
    
    func handleError(message: String){
        alert.dismiss(animated: true, completion: nil)
        print(message);
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier! {
            
        case "aliasSegue":
            let aliasDetailView = segue.destination as! AliasTableViewController
            aliasDetailView.dname = dname!
            break
            
        case "databaseSegue":
            let databaseDetailView = segue.destination as! DatabaseTableViewController
            databaseDetailView.dname = dname!
            break
            
        case "subdomainSegue":
            let subdomainDetailView = segue.destination as! SubdomainTableViewController
            subdomainDetailView.dname = dname!
            break
            
        case "mailSegue":
            let mailListView = segue.destination as! MailTableViewController
            mailListView.dname=dname!
            break;
            
        case "dnsSegue":
            let dnsListView = segue.destination as! DNSListTableViewController
            dnsListView.dname = dname!
            break
            
        case "ftpSegue":
            let ftpListView = segue.destination as! FTPListTableViewController
            ftpListView.dname = dname!
            break
            
        case "changePasswordSegue":
            let changePasswordView = segue.destination as! ChangeDomainPasswordViewController
            changePasswordView.dname = dname!
            break
        default:
            break
        }

    }
    
}
