//
//  DNSListTableViewController.swift
//  MaestroPanel
//

import UIKit

class DNSListTableViewController: UITableViewController {

    
    var dname : String?
    var dnsManager : DNSManager = DNSManager()
    var dnsRecors : NSMutableArray = []
    var TypeImage: UIImageView?
    
    let alert = UIAlertController(title: nil, message: "Yükleniyor...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="DNS Yönetimi"
        reloadDnsRecords()
    }
    
    func reloadDnsRecords(){
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        dnsManager.getDNSRecords(dname!){ result in
            
            self.dnsRecors = result.Records
            
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
        return dnsRecors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dnsRecordCell", for: indexPath) as! DNSListTableViewCell

        let record : DNSRecord = dnsRecors[(indexPath as NSIndexPath).row] as! DNSRecord
        
        if record.RecordType == "A"
        {
            cell.LblRecordType.textColor = UIColor(white:0.25, alpha:1.0)
            cell.LblRecordType.text = record.RecordType
            
            cell.LblTypeImage.backgroundColor = UIColor(white:0.25, alpha:1.0)
        }
        else if record.RecordType == "CNAME"
        {
            cell.LblRecordType.textColor = UIColor(red:0.9, green:0.45, blue:0.0, alpha:1.0)
            cell.LblRecordType.text = record.RecordType
            cell.LblRecordType.font = UIFont(name: "HelveticaNeue", size: 18)

            cell.LblTypeImage.backgroundColor = UIColor(red:0.9, green:0.45, blue:0.0, alpha:1.0)
        }
        else if record.RecordType == "NS"
        {
            cell.LblRecordType.textColor = UIColor(red:0.07, green:0.7, blue:0.6, alpha:1.0)
            cell.LblRecordType.text = record.RecordType
            cell.LblRecordType.font = UIFont(name: "HelveticaNeue", size: 18)

           cell.LblTypeImage.backgroundColor = UIColor(red:0.07, green:0.7, blue:0.6, alpha:1.0)
        }
        else if record.RecordType == "MX"
        {
            cell.LblRecordType.textColor = UIColor(red:0.82, green:0.0, blue:0.64, alpha:1.0)
            cell.LblRecordType.text = record.RecordType
            cell.LblRecordType.font = UIFont(name: "HelveticaNeue", size: 18)
            
            cell.LblValue.text = record.Value
            cell.LblValue.font = UIFont(name: "HelveticaNeue-light", size: 11)
            
            cell.LblTypeImage.backgroundColor = UIColor(red:0.82, green:0.0, blue:0.64, alpha:1.0)
        }
        else
        {
            cell.LblRecordType.textColor = UIColor(red:0.0, green:0.55, blue:0.73, alpha:1.0)
            cell.LblRecordType.text = record.RecordType
            cell.LblRecordType.font = UIFont(name: "HelveticaNeue", size: 18)

            cell.LblTypeImage.backgroundColor = UIColor(red:0.0, green:0.55, blue:0.73, alpha:1.0)
        }
        
        cell.LblName.text = record.Name
        cell.LblName.font = UIFont(name: "HelveticaNeue-light", size: 11)

//        cell.LblValue.sizeToFit()
        cell.LblValue.text = record.Value
        cell.LblValue.font = UIFont(name: "HelveticaNeue-light", size: 11)

        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Sil", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
         present(alert, animated: true, completion: nil)

        if editingStyle == .delete {
            
            let record : DNSRecord = dnsRecors[(indexPath as NSIndexPath).row] as! DNSRecord
            
            dnsManager.deleteDNSRecord(dname!,rectype: record.RecordType!, recname: record.Name!, recvalue: record.Value!, priority: record.Priority!){ result in
                self.dnsRecors.remove(record)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.dismiss(animated: false, completion: nil)
            }

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


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
        
        let addSubdomainViewController = segue.destination as! AddDnsViewController
        addSubdomainViewController.dname = dname
    }
 

}
