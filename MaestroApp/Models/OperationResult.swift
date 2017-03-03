//
//  OperationResult.swift
//  MaestroPanel
//

import Foundation
class OperationResult: Initable {
    var Code : Int32?
    var Message : String?
    var Id : Int32?
    var Name : String?
    var DomainUser : String?
    
    required init(opt1: JSON) {
        self.Code = opt1["Code"].int32Value
        self.Message = opt1["Message"].stringValue
        self.Id = opt1["Id"].int32Value
        self.Name = opt1["Name"].stringValue
        self.DomainUser = opt1["DomainUser"].stringValue
    }
}
