//
//  DNSRecordsModel.swift
//  MaestroPanel
//


import Foundation
import SwiftyJSON

class DNSRecordsModel : Initable {
    
    var ZoneType : Int32?
    var Name : String?
    var AllowZoneTransfers: Bool?
    var SeriaNumber : Int64?
    var PrimaryServer : String?
    var ResponsiblePerson : String?
    var RefreshInterval : Int64?
    var RetryInterval : Int64?
    var Expires : Int64?
    var TTL : Int64?
    
    
    var Records : NSMutableArray = NSMutableArray()
    
    required init(opt1:JSON) {
        self.ZoneType = opt1["ZoneType"].int32Value
        self.Name = opt1["Name"].stringValue
        self.AllowZoneTransfers = opt1["AllowZoneTransfers"].boolValue
        self.SeriaNumber = opt1["SerialNumber"].int64Value
        self.PrimaryServer = opt1["PrimaryServer"].stringValue
        self.ResponsiblePerson = opt1["ResponsiblePerson"].stringValue
        self.RefreshInterval = opt1["RefreshInterval"].int64Value
        self.Expires = opt1["Expires"].int64Value
        self.TTL = opt1["TTL"].int64Value
        
        for (_, subjson) in opt1["Records"] {
            Records.add(DNSRecord(opt1: subjson))
        }
    }
}

class DNSRecord: Initable {
    var RecordType : String?
    var Value : String?
    var Name : String?
    var Priority : Int64?
    
    required init(opt1: JSON) {
        RecordType = opt1["RecordType"].stringValue
        Value = opt1["Value"].stringValue
        Name = opt1["Name"].stringValue
        Priority = opt1["Priority"].int64Value
    }
}
