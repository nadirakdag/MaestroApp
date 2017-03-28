//
//  DomainListItemModel.swift
//  MaestroPanel
//

import Foundation
import SwiftyJSON

class DomainListItemModel: Initable {
    var Disk : Int32?
    var Email : Int32?
    var Id : Int32?
    var Name : String?
    var OwnerName : String?
    var Status : Int32?
    var IpAddress : String?
    var ExpirationDate : Date!
    
    
    
    required init(opt1:JSON) {
        self.Disk = opt1["Disk"].int32Value
        self.Email = opt1["Email"].int32Value
        self.Id = opt1["Id"].int32Value
        self.Name = opt1["Name"].stringValue
        self.OwnerName = opt1["OwnerName"].stringValue
        self.Status = opt1["Status"].int32Value
        self.IpAddress = opt1["IpAddr"].stringValue
        self.ExpirationDate =  Date(jsonDate: opt1["ExpirationDate"].stringValue)
    }
}
