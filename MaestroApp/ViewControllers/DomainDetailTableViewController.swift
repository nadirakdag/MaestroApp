//
//  DomainDetailTableViewController.swift
//  MaestroPanel
//

import UIKit

class DomainDetailTableViewController: UITableViewController {

    var dname : String?
    var domainManager : DomainManager = DomainManager()
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)

    
    @IBOutlet weak var LblDomainName: UILabel!
    @IBOutlet weak var LblExpirationDate: UILabel!
    @IBOutlet weak var LblOwnerName: UILabel!
    @IBOutlet weak var LblDisk: UILabel!
    @IBOutlet weak var LblEmail: UILabel!
    @IBOutlet weak var LblIpAddress: UILabel!
    
    // Static Text
    
    @IBOutlet weak var LblSonlanmaTarihi: UILabel!
    @IBOutlet weak var LblYetkili: UILabel!
    @IBOutlet weak var LblDiskKullanimi: UILabel!
    @IBOutlet weak var LblEmailSayisi: UILabel!
    @IBOutlet weak var LblIpAdresi: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = self.dname
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

        domainManager.getHostingDetail(dname!) { (result) in
            
            self.LblDomainName.text = result.Name

            self.LblSonlanmaTarihi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            self.LblSonlanmaTarihi.text = "Sonlanma Tarihi"
            self.LblSonlanmaTarihi.font = UIFont(name: "HelveticaNeue", size: 14)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            self.LblExpirationDate.text = dateFormatter.string(from: result.ExpirationDate)
            self.LblExpirationDate.font = UIFont(name: "HelveticaNeue-light", size: 14)

            self.LblYetkili.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            self.LblYetkili.text = "Yetkili"
            self.LblYetkili.font = UIFont(name: "HelveticaNeue", size: 14)
            self.LblOwnerName.text = result.OwnerName
            self.LblOwnerName.font = UIFont(name: "HelveticaNeue-light", size: 14)

            
            self.LblIpAdresi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            self.LblIpAdresi.text = "IP Adresi"
            self.LblIpAdresi.font = UIFont(name: "HelveticaNeue", size: 14)
            self.LblIpAddress.text = result.IpAddress
            self.LblIpAddress.font = UIFont(name: "HelveticaNeue-light", size: 14)


            self.LblDiskKullanimi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            self.LblDiskKullanimi.text = "Disk Kullanımı"
            self.LblDiskKullanimi.font = UIFont(name: "HelveticaNeue", size: 14)
            self.LblDisk.text = String(result.Disk!) + "%"
            self.LblDisk.font = UIFont(name: "HelveticaNeue-light", size: 14)

            
            self.LblEmailSayisi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
            self.LblEmailSayisi.text = "E-Posta"
            self.LblEmailSayisi.font = UIFont(name: "HelveticaNeue", size: 14)
            self.LblEmail.text = String(result.Email!) + " adet"
            self.LblEmail.font = UIFont(name: "HelveticaNeue-light", size: 14)

            self.dismiss(animated: false, completion: nil)

            
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    */
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
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
