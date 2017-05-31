import Foundation
import Alamofire
import SwiftyJSON


class DatabaseManager : MaestroAPI{
    func getDatabaseList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetDatabaseList"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject], completion: { (result:
            [DatabaseListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }, errcompletion: errcompletion)
    }
    
    func deleteDatabase(_ dname: String, database: String,dbtype: String, completion: @escaping (_ result: OperationResult) -> Void) {
        
        let url : String = "Domain/DeleteDatabase?format=json"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "name":dname as AnyObject, "dbtype": dbtype as AnyObject,"database":database as AnyObject]){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func createDatabase(_ dname: String, dbType: String, database: String, userName: String, password: String, quota: Int, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Domain/AddDatabase?format=json"
        let parameters : [String:AnyObject] = ["key": apiKey as AnyObject, "name":dname as AnyObject, "dbtype": dbType as AnyObject,"database":database as AnyObject,"username":userName as AnyObject,"password": password as AnyObject,"quota": quota as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addDatabaseUser(_ dname: String, dbType: String, database: String, userName: String, password: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Domain/AddDatabaseUser?format=json"
        
        let parameters : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "name":dname as AnyObject,
            "dbtype": dbType as AnyObject,
            "database":database as AnyObject,
            "username":userName as AnyObject,
            "password": password as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func deleteDatabaseUser(_ dname: String, dbType: String, database: String, userName: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Domain/DeleteDatabaseUser?format=json"
        
        let parameters : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "name":dname as AnyObject,
            "dbtype": dbType as AnyObject,
            "database":database as AnyObject,
            "username":userName as AnyObject]
        
        deleteRequestObject(url, parameters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func changeDatabaseUserPassword(_ dname: String, dbType: String, database: String, userName: String, password: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "Domain/ChangeDatabaseUserPassword?format=json"
        
        let parameters : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "name":dname as AnyObject,
            "dbtype": dbType as AnyObject,
            "database":database as AnyObject,
            "username":userName as AnyObject,
            "newpassword": password as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
}
