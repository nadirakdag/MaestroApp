//
//  ServerDetailTableViewController.swift
//  MaestroPanel
//

import UIKit

class ServerDetailTableViewController: UITableViewController {

    @IBOutlet weak var LblServerName: UILabel!
    @IBOutlet weak var LblVersion: UILabel!
    @IBOutlet weak var LblHost: UILabel!
    @IBOutlet weak var LblCompName: UILabel!
    @IBOutlet weak var LblOperatingSystem: UILabel!
    @IBOutlet weak var LblCpu: UILabel!
    
    //Static Text
    @IBOutlet weak var LblBilgiler: UILabel!
    @IBOutlet weak var LblKaynaklar: UILabel!
    
    @IBOutlet weak var LblVersiyon: UILabel!
    @IBOutlet weak var LblIpAdresi: UILabel!
    @IBOutlet weak var LblSunucuAdi: UILabel!
    @IBOutlet weak var LblIslemci: UILabel!
    @IBOutlet weak var LblIsletimSistemi: UILabel!

    
    var resource : ServerManager = ServerManager()
    var serverDetail : ServerListItemModel?
    var resourceValues : NSMutableArray=[]
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = serverDetail?.Name

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.LblBilgiler.text = "Bilgiler"
        self.LblBilgiler.font = UIFont(name: "HelveticaNeue-ultralight", size: 24)
        
        
        self.LblVersiyon.text = "Versiyon"
        self.LblVersiyon.font = UIFont(name: "HelveticaNeue", size: 14)
        self.LblVersiyon.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)

        self.LblVersion.text = serverDetail?.Version
        self.LblVersion.font = UIFont(name: "HelveticaNeue-light", size: 14)
        
        self.LblIpAdresi.text = "IP veya Host Adı"
        self.LblIpAdresi.font = UIFont(name: "HelveticaNeue", size: 14)
        self.LblIpAdresi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        
        self.LblHost.text = serverDetail?.Host
        self.LblHost.font = UIFont(name: "HelveticaNeue-light", size: 14)

        
        self.LblSunucuAdi.text = "Sunucu Adı"
        self.LblSunucuAdi.font = UIFont(name: "HelveticaNeue", size: 14)
        self.LblSunucuAdi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        
        self.LblCompName.text = serverDetail?.ComputerName
        self.LblCompName.font = UIFont(name: "HelveticaNeue-light", size: 14)


        self.LblIslemci.text = "İşlemci"
        self.LblIslemci.font = UIFont(name: "HelveticaNeue", size: 14)
        self.LblIslemci.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        
        self.LblCpu.text = serverDetail?.Cpu
        self.LblCpu.font = UIFont(name: "HelveticaNeue-light", size: 12.5)

        self.LblIsletimSistemi.text = "İşletim Sistemi"
        self.LblIsletimSistemi.font = UIFont(name: "HelveticaNeue", size: 14)
        self.LblIsletimSistemi.textColor = UIColor(red:0.17, green:0.6, blue:0.72, alpha:1.0)
        self.LblOperatingSystem.text = serverDetail?.OperatingSystem
        self.LblOperatingSystem.font = UIFont(name: "HelveticaNeue-light", size: 14)

        
        self.LblKaynaklar.text = "Kaynaklar"
        self.LblKaynaklar.font = UIFont(name: "HelveticaNeue-ultralight", size: 24)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        resource.getServerResources((serverDetail!.Name)!) { (result) in
            self.resourceValues = NSMutableArray(array: result)
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)


        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
