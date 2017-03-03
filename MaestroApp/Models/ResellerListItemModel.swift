//
//  ResellerListItemModel.swift
//  MaestroPanel
//

import Foundation
class ResellerListItemModel: Initable {
    var LastName : String?
    var Email : Int32?
    var Id : Int32?
    var FirstName : String?
    var ApiAccess : Bool?
    var LoginType : Bool?
    var Organization: String?
    var ExpirationDate : Date!
    var Status: String?
    var Username : String?
    
    required init(opt1:JSON) {
        self.LastName = opt1["LastName"].stringValue
        self.Email = opt1["Email"].int32Value
        self.Id = opt1["Id"].int32Value
        self.FirstName = opt1["FirstName"].stringValue
        self.Status = opt1["Status"].stringValue
        self.ExpirationDate = Date(jsonDate: opt1["ExpirationDate"].stringValue)
        self.Username = opt1["Username"].stringValue
        self.ApiAccess = opt1["ApiAccess"].boolValue
        self.LoginType = opt1["LoginType"].boolValue
        self.Organization = opt1["Organization"].stringValue
    }
}
