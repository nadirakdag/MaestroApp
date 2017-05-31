import Foundation
import Alamofire
import SwiftyJSON


class DomainManager : MaestroAPI{
    func getHostingDetail(_ dname: String, completion: @escaping (_ result: DomainListItemModel)-> Void, errcompletion: @escaping (_ result: String)-> Void)  {
        
        let url : String = "Domain/GetListItem"
        let params : [String: AnyObject] =  [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "name": dname as AnyObject
        ]
        getRequestObject(url, paramaters: params, completion: completion, errcompletion: errcompletion)
    }
    
    func getDomainList(_ isReseller: Bool, resellerUserName : String?, completion: @escaping (_ result:NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "\(isReseller ? "Reseller/GetDomains":"Domain/GetList")"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "username": resellerUserName as AnyObject
        ]
        
        getRequestArrays(url, parameters: params, completion: { (result: [DomainListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    
    func addDomain(_ dname: String, username: String, password: String, activiteDomainUser: Bool, firstName: String, lastName: String, email: String, isReseller: Bool, resellerName: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        var url : String
        var parameters : [String:AnyObject]
        
        if isReseller{
            url = "reseller/AddDomain?format=json"
            parameters = [ "key":apiKey as AnyObject,
                           "domainName": dname as AnyObject,
                           "planAlias": "testbayi" as AnyObject,
                           "domainUsername": username as AnyObject,
                           "domainPassword":password as AnyObject,
                           "activedomainuser":(activiteDomainUser as Bool) as AnyObject,
                           "firstname": firstName as AnyObject,
                           "lastname": lastName as AnyObject,
                           "email": email as AnyObject,
                           "username": resellerName as AnyObject
            ]
            
        } else {
            url = "Domain/create?format=json"
            parameters = [ "key":apiKey as AnyObject,
                           "name": dname as AnyObject,
                           "planAlias": "default" as AnyObject,
                           "username": username as AnyObject,
                           "password":password as AnyObject,
                           "activedomainuser":(activiteDomainUser as Bool) as AnyObject,
                           "firstname": firstName as AnyObject,
                           "lastname": lastName as AnyObject,
                           "email": email as AnyObject
            ]
        }
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func changePassword(_ dname: String, newPass: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Domain/Password?format=json"
        let parameters : [String: AnyObject] = ["key":apiKey as AnyObject, "name": dname as AnyObject, "newpassword": newPass as AnyObject]
        
        postRequestObject(url, paramters: parameters){ (result:OperationResult) -> Void in
            completion(result)
        }
    }
    
    func deleteDomain(_ isReseller: Bool, userName: String, dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "\(isReseller ? "Reseller/DeleteDomain" : "Domain/Delete")"
        
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name": dname as AnyObject,
            "format":"json" as AnyObject,
            "username": userName as AnyObject,
            "domainName" : dname as AnyObject
        ]
        
        deleteRequestObject(url, parameters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func startDomain(_ dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "Domain/start?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name": dname as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func stopDomain(_ dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "Domain/stop?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name": dname as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
}
