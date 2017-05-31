import Foundation
import Alamofire
import SwiftyJSON


class ResellerManager: MaestroAPI {
    func getResellerList(_ completion: @escaping (_ result: NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Reseller/GetResellers"
        let params : [String: AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion: {
            (result: [ResellerListItemModel] ) in
            completion(NSMutableArray(array: result))
        }, errcompletion : errcompletion)
    }
    
    func changePassword(_ username: String, newPass: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Reseller/Password?format=json"
        let parameters : [String: AnyObject] = [
            "key":apiKey as AnyObject,
            "username": username as AnyObject,
            "newpassword": newPass as AnyObject
        ]
        
        postRequestObject(url, paramters: parameters){ (result:OperationResult) -> Void in
            completion(result)
        }
    }
    
    func deleteReseller(_ username: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "Reseller/Delete?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "username": username as AnyObject
        ]
        
        deleteRequestObject(url, parameters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func startReseller(_ username: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "Reseller/start?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "username": username as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func stopReseller(_ dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "Reseller/stop?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "username": dname as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func getIpAddresses(_ userName: String, completion: @escaping (_ result: NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void) {
        let url : String = "/Reseller/GetIPAddrList"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "username" : userName as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion:  { (result: [ResellerIpAddrModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion:errcompletion)
    }
    
    func createReseller(username : String, password : String, planAlias: String, firstName: String, lastName : String, mailAddress : String, organization : String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "/Reseller/Create";
        let params : [String:AnyObject] = [
            "key" : apiKey as AnyObject,
            "format" : "json" as AnyObject,
            "username" : username as AnyObject,
            "password" : password as AnyObject,
            "planAlias" : planAlias as AnyObject,
            "firstName" : firstName as AnyObject,
            "lastName" : lastName as AnyObject,
            "email" : mailAddress as AnyObject,
            "organization" : organization as AnyObject
        ]
        print("creating reseeller")
        postRequestObject(url, paramters: params) {
            (result: OperationResult) -> Void in
            completion(result);
        }
    }
}
