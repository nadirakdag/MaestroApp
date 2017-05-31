import Foundation
import Alamofire
import SwiftyJSON

class SubdomainManager : MaestroAPI{
    func getSubdomainList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetSubDomains"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject], completion: { (result:
            [SubdomainListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func deleteSubdomain(_ dname: String, subdomain: String, completion: @escaping (_ result:OperationResult) -> Void){
        
        let url : String = "Domain/DeleteSubDomain"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject, "subdomain": subdomain as AnyObject]){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addSubDomain(_ dname: String, subDomain: String, ftpUser: String, completion: @escaping (_ result:OperationResult)-> Void){
        
        let url : String = "Domain/AddSubDomain?format=json"
        let parameters : [String:AnyObject] = ["name":dname as AnyObject, "subdomain":subDomain as AnyObject,"ftpuser":ftpUser as AnyObject,"key":apiKey as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result:OperationResult) in
            completion(result)
        }
    }
}
