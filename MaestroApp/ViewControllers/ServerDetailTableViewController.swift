import UIKit

class ServerDetailTableViewController: UITableViewController {

    @IBOutlet weak var LblServerName: UILabel!
    @IBOutlet weak var LblVersion: UILabel!
    @IBOutlet weak var LblHost: UILabel!
    @IBOutlet weak var LblCompName: UILabel!
    @IBOutlet weak var LblOperatingSystem: UILabel!
    @IBOutlet weak var LblCpu: UILabel!
    
    
    var resource : ServerManager = ServerManager()
    var serverDetail : ServerListItemModel?
    var resourceValues : NSMutableArray=[]
    
    let alert = AlertViewController.getUIAlertLoding("LoadingServerDetail")

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.title = serverDetail?.Name

        self.LblVersion.text = serverDetail?.Version
        self.LblHost.text = serverDetail?.Host
        self.LblCompName.text = serverDetail?.ComputerName
        self.LblCpu.text = serverDetail?.Cpu
        self.LblOperatingSystem.text = serverDetail?.OperatingSystem
        
        present(alert, animated: true, completion: nil)
        resource.getServerResources((serverDetail!.Name)!, completion:  { (result) in
            self.resourceValues = NSMutableArray(array: result)
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
        return resourceValues.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceIdentifier", for: indexPath) as! ResourceTableViewCell
     
        let resource = resourceValues[(indexPath as NSIndexPath).row] as! ServerResourceItemModel
     
        cell.lblResourceName.text = resource.ResourceName
        cell.lblResourceValue.text = String(resource.Total)
        cell.lblUsedValue.text = String(resource.Used)
        
        return cell
    }
}
