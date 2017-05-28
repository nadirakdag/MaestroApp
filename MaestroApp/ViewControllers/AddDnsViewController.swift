import UIKit

class AddDnsViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    var dname : String?
    let dnsManager : DNSManager = DNSManager()

    
    @IBOutlet weak var txtDnsRecordName: UITextField!
    @IBOutlet weak var txtDnsRecordValue: UITextField!
    @IBOutlet weak var txtDnsRecordPriority: UITextField!
    @IBOutlet weak var pickerDnsRecordType: UIPickerView!
    
    var pickerData :[String] = [String]()
    
    var pickerSelectedData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.pickerDnsRecordType.delegate = self
        self.pickerDnsRecordType.dataSource = self
        
       pickerData = [
            "AFSDB",
            "ATMA",
            "A",
            "HINFO",
            "AAAA",
            "CNAME",
            "TXT",
            "PTR",
            "MX",
            "NS",
            "MG",
            "MB",
            "MINFO",
            "MR",
            "RP",
            "RT",
            "SRV",
            "SIG",
            "WKS",
            "X25",
            "KEY"
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveDnsRecord(_ sender: Any) {
         self.present(AlertViewController.getUIAlertLoding("AddingNewDNSRecord"), animated: true, completion:nil)
        
        var priority : Int64 = 0
        if txtDnsRecordPriority.text == nil {
            priority = Int64(txtDnsRecordPriority.text!)!
        }
        
       dnsManager.addDnsRecord(dname!, rectype: pickerSelectedData, recname: txtDnsRecordName.text!, recvalue: txtDnsRecordValue.text!, priority: priority, completion: handleAddDnsResult)
        
    }

    func handleAddDnsResult(_ result: OperationResult){
        if result.Code == -1 {
            self.dismiss(animated: false, completion: nil)
            self.present(AlertViewController.getUIAlertInfo(result.Message!), animated: true, completion:nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.navigationController!.popViewController(animated: true)
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerSelectedData = pickerData[row]
        if pickerSelectedData == "MX" {
            txtDnsRecordPriority.isEnabled = true
        }
        else {
            txtDnsRecordPriority.isEnabled = false
        }
    }
}
