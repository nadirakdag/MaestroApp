//
//  ServerListItemModel.swift
//  MaestroPanel
//

import SwiftyJSON

class ServerListItemModel: Initable {
    
    var Id : Int32?
    var Name : String?
    var Host : String?
    var ComputerName : String?
    var OperatingSystem : String?
    var Version : String?
    var Cpu : String?
    var Status : Int32?
    
    required init (opt1: JSON){
        self.Id = opt1["Id"].int32Value
        self.Name = opt1["Name"].string
        self.Host = opt1["Host"].string
        self.ComputerName = opt1["ComputerName"].string
        self.OperatingSystem = opt1["OperatingSystem"].string
        self.Version = opt1["Version"].string
        self.Cpu = opt1["Cpu"].string
        self.Status = opt1["Status"].int32Value
    }
}
