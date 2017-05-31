import Foundation
import Alamofire
import SwiftyJSON


class MailManager : MaestroAPI{
    func getMailList(_ dname: String, completion: @escaping (_ result:MailListModel) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetMailList"
        getRequestObject(url, paramaters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject], completion: { (result:
            MailListModel) -> Void in
            completion(result)
        }, errcompletion: errcompletion)
    }
    
    func deleteMailbox(_ dname: String, account: String, completion: @escaping (_ result:OperationResult)->Void) {
        
        let url : String = "Domain/DeleteMailbox?format=json"
        postRequestObject(url, paramters: ["key": apiKey as AnyObject,  "name": dname as AnyObject, "account": account as AnyObject]){
            (result:OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addMailbox(_ dname: String, account: String, password: String, quota: Int, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url: String = "Domain/AddMailBox?format=json"
        
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name":dname as AnyObject,
            "account": account as AnyObject,
            "password": password as AnyObject,
            "quota": quota as AnyObject,
            "redirect":false as AnyObject,
            "remail":"" as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result:OperationResult) in
            completion(result)
        }
        
    }
    
    func changeQuota(_ dname: String, account: String, quota: Int, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url: String = "Domain/ChangeMailBoxQuota?format=json"
        
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name":dname as AnyObject,
            "account": account as AnyObject,
            "quota": quota as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result:OperationResult) in
            completion(result)
        }
        
    }
    
    
    func changePassword(_ dname: String, account: String, password: String,  completion: @escaping (_ result: OperationResult)-> Void){
        
        let url: String = "Domain/ChangeMailBoxPassword?format=json"
        
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name":dname as AnyObject,
            "account": account as AnyObject,
            "password": password as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result:OperationResult) in
            completion(result)
        }
        
    }    
}
