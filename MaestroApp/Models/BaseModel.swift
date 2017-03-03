//
//  BaseModel.swift
//  MaestroPanel
//

import Foundation

protocol Initable {
    init(opt1: JSON)
}

class BaseModel : NSObject{
    var ErrorCode : Int32?
    var Message : String?
    var StatusCode : Int32?
    
    init (opt1: JSON) {
        self.ErrorCode = opt1["ErrorCode"].int32Value
        self.Message = opt1["Message"].stringValue
        self.StatusCode = opt1["StatusCode"].int32Value
    }
    
}

class BaseModelForArrays <T: Initable>: BaseModel {
    
    var Detail : [T]!
    
    override  init (opt1: JSON) {
        super.init(opt1: opt1)
        
        Detail = [T]()
        for (_, subjson) in opt1["Details"] {
            self.Detail.append(T(opt1: subjson))
        }
    }
}

class BaseModelForObjects <T: Initable> : BaseModel {
    
    var Detail : T?
    
    override  init (opt1: JSON) {
        super.init(opt1: opt1)
        self.Detail = T(opt1: opt1["Details"])
    }
}

