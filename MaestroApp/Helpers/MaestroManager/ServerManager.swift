import Foundation
import Alamofire
import SwiftyJSON

class ServerManager : MaestroAPI {
    
    func getServerList(_ completion: @escaping (_ result: NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void) {
        
        let url : String = "/Server/GetServerList"
        let params : [String: AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion: { (result: [ServerListItemModel]) in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func getServerResources(_ serverName: String,completion: @escaping (_ result: NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void) {
        
        let url : String = "/Server/GetResources"
        let params : [String: AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "servername": serverName as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion: { (result: [ServerResourceItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func getIpAddresses(_ completion: @escaping (_ result: NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void) {
        
        let url : String = "/Server/GetIpAddrList"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion:  { (result: [ServerIpAddrModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func addIpAddrres(_ serverName: String,nicName : String, ipAddr: String, subNet:String, isShared:Bool, isDedicated:Bool, isExclusive:Bool, completion: @escaping (_ result: OperationResult) -> Void) {
        let url : String = "/Server/AddIpAddr"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "servername": serverName as AnyObject,
            "nicName": nicName as AnyObject,
            "ipAddr": ipAddr as AnyObject,
            "subNet": subNet as AnyObject,
            "isShared" : isShared as AnyObject,
            "isDedicated" : isDedicated as AnyObject,
            "isExclusive": isExclusive as AnyObject
        ]
        postRequestObject(url, paramters: params){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func deleteIpAddr(_ serverName: String, nicName : String, ipAddr: String, completion: @escaping (_ result: OperationResult) -> Void) {
        let url : String = "/Server/DeleteIpAddr"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "servername": serverName as AnyObject,
            "ipAddr":ipAddr as AnyObject,
            "nicName" : nicName as AnyObject,
            
            ]
        deleteRequestObject(url, parameters: params){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
}
