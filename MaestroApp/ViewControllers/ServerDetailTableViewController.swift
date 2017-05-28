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
        self.LblVersion.font = UIFont(name: "HelveticaNeue-light", size: 14)
        
        self.LblHost.text = serverDetail?.Host
        self.LblHost.font = UIFont(name: "HelveticaNeue-light", size: 14)

        self.LblCompName.text = serverDetail?.ComputerName
        self.LblCompName.font = UIFont(name: "HelveticaNeue-light", size: 14)

        self.LblCpu.text = serverDetail?.Cpu
        self.LblCpu.font = UIFont(name: "HelveticaNeue-light", size: 12.5)

        self.LblOperatingSystem.text = serverDetail?.OperatingSystem
        self.LblOperatingSystem.font = UIFont(name: "HelveticaNeue-light", size: 14)

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
     
        cell.lblKaynak.text = "Kaynak"
        cell.lblKaynak.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.lblKaynak.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.lblResourceName.text = resource.ResourceName
        cell.lblResourceName.font = UIFont(name: "HelveticaNeue-light", size: 14)
     
        cell.lblToplam.text = "Toplam"
        cell.lblToplam.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.lblToplam.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.lblResourceValue.text = String(resource.Total)
        cell.lblResourceValue.font = UIFont(name: "HelveticaNeue-light", size: 14)

        cell.lblKullanilan.text = "Kullanılan"
        cell.lblKullanilan.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.lblKullanilan.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        cell.lblUsedValue.text = String(resource.Used)
        cell.lblUsedValue.font = UIFont(name: "HelveticaNeue-light", size: 14)

     
        return cell
    }
}
