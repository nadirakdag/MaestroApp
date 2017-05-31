//
//  FtpListItemModel.swift
//  MaestroPanel
//

import Foundation
import SwiftyJSON

class FtpListItemModel: Initable {
    var Users : [FtpUserItemModel]
    
    required init(opt1: JSON) {
        self.Users = [FtpUserItemModel]()
        for (_, subjson) in opt1["Users"] {
            self.Users.append(FtpUserItemModel(opt1: subjson))
        }
    }
}


class FtpUserItemModel : Initable {
    var UserName : String?
    var HomePath : String?
    var Status : Int32?
    var ReadOnly : Bool
    
    required init(opt1:JSON) {
        self.UserName = opt1["Username"].stringValue
        self.HomePath = opt1["HomePath"].stringValue
        self.ReadOnly=opt1["ReadOnly"].boolValue
        self.Status=opt1["Status"].int32Value
    }

}
