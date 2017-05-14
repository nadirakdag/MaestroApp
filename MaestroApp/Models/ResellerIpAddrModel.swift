//
//  ResellerIpAddrModel.swift
//  MaestroApp
//
//  Created by Nadir on 14/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import SwiftyJSON

class ResellerIpAddrModel: NSObject,Initable {
   
    var Nic : String?
    var IpAddr : String?
    
    var isDedicated : Bool?
    var isExclusive : Bool?
    var isShared : Bool?
    
    
    required init(opt1:JSON) {
        
        self.Nic = opt1["Nic"].stringValue
        self.IpAddr = opt1["IpAddr"].stringValue
        
        self.isDedicated = opt1["isDedicated"].boolValue
        self.isExclusive = opt1["isExclusive"].boolValue
        self.isShared = opt1["isShared"].boolValue
    }
}
