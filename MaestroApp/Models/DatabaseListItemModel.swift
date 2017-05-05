//
//  DatabaseListItemModel.swift
//  MaestroPanel
//

import SwiftyJSON

class DatabaseListItemModel: NSObject,Initable {
    var Name : String?
    var DiskQuota : Int64?
    var DiskUsage : Int64?
    var DbType : String?
    var Users : [DbUserListItemModel]
    
    required init(opt1:JSON) {
        self.Name = opt1["Name"].stringValue
        self.DiskQuota = opt1["DiskQuota"].int64Value
        self.DiskUsage = opt1["DiskUsage"].int64Value
        self.DbType = opt1["DbType"].stringValue
        
        self.Users = [DbUserListItemModel]()
        for (_, subjson) in opt1["Users"] {
            self.Users.append(DbUserListItemModel(opt1: subjson))
        }
        
        
    }
}
