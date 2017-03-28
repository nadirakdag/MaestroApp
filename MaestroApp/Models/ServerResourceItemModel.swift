//
//  ServerResourceItemModel.swift
//  MaestroPanel
//

import SwiftyJSON

class ServerResourceItemModel : Initable {
    var ResourceType : String
    var ResourceName : String
    var Total : Int32
    var Used : Int32
    
    required init (opt1: JSON){
        self.ResourceName = opt1["resourceName"].stringValue
        self.ResourceType = opt1["resourceType"].stringValue
        self.Total = opt1["Total"].int32Value
        self.Used = opt1["Used"].int32Value
    }
}
