//
//  ServerIpAddrModel.swift
//  MaestroApp
//
//  Created by Nadir on 14/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import SwiftyJSON

class ServerIpAddrModel: NSObject,Initable {
    var Id : Int32?
    var ServerId : Int32?
    var NicId:Int32?
    var NicName : String?
    var IpAddr : String?
    var Subnet : String?
    var isDedicated : Bool?
    var isExclusive : Bool?
    var isShared : Bool?
    var domainCount : Int32?
    
    required init(opt1:JSON) {
        self.Id = opt1["Id"].int32Value
        self.ServerId = opt1["ServerId"].int32Value
        self.NicId = opt1["NicId"].int32Value
        self.domainCount = opt1["domainCount"].int32Value
        
        self.NicName = opt1["NicName"].stringValue
        self.IpAddr = opt1["IpAddr"].stringValue
        self.Subnet = opt1["Subnet"].stringValue
        
        self.isDedicated = opt1["isDedicated"].boolValue
        self.isExclusive = opt1["isExclusive"].boolValue
        self.isShared = opt1["isShared"].boolValue
    }
}
