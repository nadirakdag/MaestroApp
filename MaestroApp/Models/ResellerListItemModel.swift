//
//  ResellerListItemModel.swift
//  MaestroPanel
//

import SwiftyJSON

class ResellerListItemModel: NSObject,Initable {
    var LastName : String?
    var Email : String?
    var Id : Int32?
    var FirstName : String?
    var ApiAccess : Bool?
    var LoginType : Bool?
    var Organization: String?
    var ExpirationDate : Date!
    var Status: Int32?
    var Username : String?
    
    required init(opt1:JSON) {
        self.LastName = opt1["LastName"].stringValue
        self.Email = opt1["Email"].stringValue
        self.Id = opt1["Id"].int32Value
        self.FirstName = opt1["FirstName"].stringValue
        self.Status = opt1["Status"].int32Value
        self.ExpirationDate = Date(jsonDate: opt1["ExpirationDate"].stringValue)
        self.Username = opt1["Username"].stringValue
        self.ApiAccess = opt1["ApiAccess"].boolValue
        self.LoginType = opt1["LoginType"].boolValue
        self.Organization = opt1["Organization"].stringValue
    }
}
