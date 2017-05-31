import Foundation
import Alamofire
import SwiftyJSON

class AliasManager : MaestroAPI{
    func getAliasList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetDomainAliases"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject], completion: { (result:
            [AliasListItemModel]) -> Void in
            print(result)
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func deleteAlias(_ dname: String, alias: String, completion: @escaping (_ result:OperationResult)-> Void){
        
        let url : String = "Domain/DeleteDomainAlias"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject, "alias":alias as AnyObject]) { (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addAlias(_ dname: String, alias: String, completion: @escaping (_ result:OperationResult)-> Void) {
        
        let url : String = "Domain/AddDomainAlias?format=json"
        let parameters : [String:AnyObject] = ["key": apiKey as AnyObject, "name": dname as AnyObject, "alias": alias as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) in
            completion(result)
        }
        
    }
}
