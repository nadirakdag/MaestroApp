import UIKit

class ServerTableViewController: UITableViewController {
    
    var serverList : NSMutableArray = []
    let cellIdentitfier : String = "ServerItemIdentifier"
    var StatusImage: UIImageView?
    
    let alert = AlertViewController.getUIAlertLoding("LoadingServerList")
    let api : ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            loadServers()
        } else {
            
            let alertTitle : String = NSLocalizedString("NetworkInfoTitle", comment: "")
            let alertMessage : String = NSLocalizedString("NetworkInfoMessage", comment: "")
            let alert = UIAlertController(title: alertTitle, message: alertMessage,  preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadServers(){
        
        present(alert, animated: true, completion: nil)
        api.getServerList ( { response in
            self.serverList = response
            self.tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitfier, for: indexPath) as! ServerListTableViewCell
        
        print(self.serverList)
        let data = self.serverList[(indexPath as NSIndexPath).row] as! ServerListItemModel
        
        var imageForStatus : UIImage
        
        if data.Status == 1 {
            imageForStatus = UIImage(named:"working")!
        }
        else{
            imageForStatus = UIImage(named: "stopped")!
        }
        
        cell.LblStatusImage.image = imageForStatus
        cell.LblServerName.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.LblServerName.text = data.Name
        cell.LblOperatingSystem.text = data.OperatingSystem
        cell.LblHost.text = data.Host

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let serverDetailView = segue.destination as! ServerDetailTableViewController
        if let serverCell = sender as? ServerListTableViewCell{
            let indexPath = self.tableView.indexPath(for: serverCell)
            let serverModel : ServerListItemModel = self.serverList[((indexPath as NSIndexPath?)?.row)!] as! ServerListItemModel
            
            serverDetailView.serverDetail = serverModel
        }
    }
}
