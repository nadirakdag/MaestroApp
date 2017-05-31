import Foundation
import Alamofire
import SwiftyJSON

class FtpManager : MaestroAPI{
    func getFtpList(_ dname: String, completion: @escaping (_ result:FtpListItemModel) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetFtpAccounts"
        let params : [String: AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "name": dname as AnyObject
        ]
        
        getRequestObject(url, paramaters : params, completion: { (result:
            FtpListItemModel) -> Void in
            completion(result)
        }, errcompletion: errcompletion)
    }
    
    func deleteFtpAccount(_ dname: String, account: String, completion: @escaping (_ result:OperationResult) -> Void){
        
        let url : String = "Domain/DeleteFtpAccount?format=json"
        postRequestObject(url, paramters: ["key": apiKey as AnyObject, "name": dname as AnyObject, "account": account as AnyObject]){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addFtpAccount(_ dname: String, account: String, password: String, readOnly: Bool, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "Domain/AddFtpAccount?format=json"
        let parameters: [String:AnyObject] = ["key":apiKey as AnyObject, "name":dname as AnyObject, "account":account as AnyObject,"password":password as AnyObject,"homePath":"\\" as AnyObject,"ronly":String(readOnly) as AnyObject]
        
        postRequestObject(url, paramters: parameters){ (result: OperationResult) in
            completion(result)
        }
        
    }
    
    func ChangePasswordOfFtpAccount(_ dname: String, account: String, password: String, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "Domain/ChangeFtpPassword?format=json"
        let parameters: [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name":dname as AnyObject,
            "account":account as AnyObject,
            "newpassword":password as AnyObject,
            "suppress_password_policy": true as AnyObject
        ]
        
        postRequestObject(url, paramters: parameters){ (result: OperationResult) in
            completion(result)
        }
        
    }
}


