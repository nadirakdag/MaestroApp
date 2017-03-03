//
//  MailListModel.swift
//  MaestroPanel
//


import Foundation
class MailListModel: Initable {

    var Quota : Int32?
    var Name : String?
    var Accounts : NSMutableArray = NSMutableArray()
    
    required init(opt1:JSON) {
        self.Quota  = opt1["Id"].int32Value
        self.Name = opt1["Name"].stringValue
        
        for (_, subjson) in opt1["Accounts"] {
            Accounts.add(AccountListItem(opt1: subjson))
        }
        
    }
}

class AccountListItem: Initable {
    
    var Name : String?
    var Status : Int32?
    var Quota : Int32?
    var Usage : Int32?
    
    required init(opt1: JSON) {
        self.Name = opt1["Name"].stringValue
        self.Status = opt1["Status"].int32Value
        self.Quota = opt1["Quota"].int32Value
        self.Usage = opt1["Usage"].int32Value
    }
}
