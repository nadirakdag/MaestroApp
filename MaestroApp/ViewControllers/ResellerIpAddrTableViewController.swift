import UIKit

class ResellerIpAddrTableViewController: UITableViewController {

    var resellerUserName : String = ""
    let resellerManager : ResellerManager = ResellerManager()
    var ipAddrList : NSMutableArray = []
    
    var alert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIpAddress()
    }

    func loadIpAddress(){
        
         alert = AlertViewController.getUIAlertLoding("LoadingIpAddresses")
        self.present(alert!, animated: true, completion: nil)
        
        resellerManager.getIpAddresses(resellerUserName, completion: { result in
            self.ipAddrList = result
            self.tableView.reloadData()
            self.alert?.dismiss(animated: true, completion: nil)
        }, errcompletion: handleError)
    }

    func handleError(message: String){
        alert?.dismiss(animated: true, completion: nil)
        print(message);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ipAddrList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resellerIpAddrCell", for: indexPath) as! ResellerIpAddrTableViewCell

        let index = (indexPath as NSIndexPath).row
        let ipAddr = ipAddrList[index] as! ResellerIpAddrModel
        
        cell.lblNicName.text = ipAddr.Nic!
        cell.lblNicName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        
        cell.lblIpAddr.text = ipAddr.IpAddr!
        
        if ipAddr.isDedicated! {
            cell.lblStatus.text = NSLocalizedString("DedicatedIP", comment: "")
        }
        else if ipAddr.isShared! {
            cell.lblStatus.text = NSLocalizedString("SharedIP", comment: "")
        }
        else if ipAddr.isExclusive! {
            cell.lblStatus.text = NSLocalizedString("SystemIP", comment: "")
        }

        return cell
    }
}
