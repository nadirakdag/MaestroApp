import UIKit

class ResellerDetailTableViewController: UITableViewController {

    var reseller : ResellerListItemModel?
    
    @IBOutlet weak var lblNameLastname: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblExpirationDate: UILabel!
    @IBOutlet weak var lblMailAddress: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = reseller?.Username
        lblNameLastname.text = "\((reseller?.FirstName)!) \((reseller?.LastName)!)"
        lblUserName.text = reseller?.Username
        lblOrganization.text = reseller?.Organization
        lblMailAddress.text = reseller?.Email
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.lblExpirationDate.text = dateFormatter.string(from: (reseller?.ExpirationDate)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            
        case "resellerDomainSegue":
            let domainListView = segue.destination as! DomainTableViewController
            domainListView.isReseller = true
            domainListView.resellerName = (reseller?.Username!)!
            break
            
        case "resellerPasswordChangeSegue":
            let databaseDetailView = segue.destination as! ResellerChangePasswordViewController
            databaseDetailView.userName = (reseller?.Username!)!
            break
        case "resellerIpAddrSegue":
            let ipAddrTableView = segue.destination as! ResellerIpAddrTableViewController
            ipAddrTableView.resellerUserName = (reseller?.Username!)!
            break
        default:
            break
        }
    }

}
