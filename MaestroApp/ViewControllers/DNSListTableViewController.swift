import UIKit

class DNSListTableViewController: UITableViewController {

    
    var dname : String?
    var dnsManager : DNSManager = DNSManager()
    var dnsRecors : NSMutableArray = []
    var TypeImage: UIImageView?
    
    let alert = AlertViewController.getUIAlertLoding("LoadingDNSRecords")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDnsRecords()
    }
    
    func reloadDnsRecords(){
        present(alert, animated: true, completion: nil)
        dnsManager.getDNSRecords(dname!, completion: { result in
            self.dnsRecors = result.Records
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

        
        cell.LblValue.text = record.Value
        cell.LblValue.font = UIFont(name: "HelveticaNeue-light", size: 11)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteActionButton = NSLocalizedString("Delete", comment: "")
        let deleteButton = UITableViewRowAction(style: .default, title: deleteActionButton, handler: { (action, indexPath) in
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
         present(alert, animated: true, completion: nil)

        if editingStyle == .delete {
            
            let record : DNSRecord = dnsRecors[(indexPath as NSIndexPath).row] as! DNSRecord
            
            dnsManager.deleteDNSRecord(dname!,rectype: record.RecordType!, recname: record.Name!, recvalue: record.Value!, priority: record.Priority!){ result in
                self.dnsRecors.remove(record)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addSubdomainViewController = segue.destination as! AddDnsViewController
        addSubdomainViewController.dname = dname
    }
 

}
