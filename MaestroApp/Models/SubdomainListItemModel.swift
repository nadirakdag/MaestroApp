//
//  SubdomainListItemModel.swift
//  MaestroPanel
//

import SwiftyJSON

class SubdomainListItemModel: Initable {
    var Name : String?
    var FtpUser : String?
    var Support : String?
    
    required init(opt1:JSON) {
        self.Name = opt1["Name"].stringValue
        self.FtpUser = opt1["FtpUser"].stringValue
        self.Support = opt1["Support"].stringValue
        
        
    }
}
