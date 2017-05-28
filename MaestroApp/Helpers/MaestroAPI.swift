//
//  MaestroPanel.swift
//  MaestroPanel
//

import Foundation
import Alamofire
import SwiftyJSON

class MaestroAPI {
    
    let apiKeyObjectKey : String = "apiKey"
    let apiUrlObjectKey : String = "apiUrl"
    
    let preferences = UserDefaults.standard
    
    var apiKey : String {
        return preferences.string(forKey: apiKeyObjectKey)!
    }
    
    var apiUrl : String  {
       return preferences.string(forKey: apiUrlObjectKey)!
    }
    
    func getRequest(_ url: String, parameters: [String: AnyObject], completion: @escaping (_ result: JSON) -> Void, errcompletion: @escaping (_ result: String) -> Void) {
        print(parameters)
        print(url)
        
        let _url = "http://\(apiUrl):9715/Api/v1/\(url)"
        
        let headers: HTTPHeaders = [ "Accept-Language": "tr-tr" ]
        Alamofire.request(_url, method: .get, parameters: parameters, headers: headers)
            .responseJSON { response in
            
                if let error = response.result.error {
                    print("error calling DELETE on /todos/1")
                    print(error)
                    errcompletion(error.localizedDescription)
                }
                
                if let json = response.result.value {
                    print(json)
                    completion(JSON(json)["Details"])
                }
                else {
                    print(response.result.error.debugDescription)
                }
            
        }
    }
    
    func deleteRequest(_ url: String, parameters: [String:AnyObject], completion:@escaping (_ result: JSON) -> Void){
        print(url)
        print(parameters)
         let _url = "http://\(apiUrl):9715/Api/v1/\(url)"
        Alamofire.request(_url, method: .delete, parameters: parameters).responseJSON{ response in
            if let json = response.result.value {
                print(url)
                print(json)
                completion(JSON(json)["Details"])
            }
        }
    }
    
    func postRequest(_ url: String, parameters: [String:AnyObject], completion: @escaping (_ result: JSON) -> Void){
        let _url = "http://\(apiUrl):9715/Api/v1/\(url)"
        print(_url)
        print(parameters)
        
        Alamofire.request( _url, method: .post,parameters: parameters)
        .responseJSON{ response in
            if let json = response.result.value {
                print(json)
                completion(JSON(json)["Details"])
            }
        }
    }
    
    
    func getRequestArrays<T:Initable>(_ url:String, parameters: [String: AnyObject], completion: @escaping (_ result: [T]) -> Void, errcompletion: @escaping (_ result: String) -> Void){
        
        getRequest(url, parameters: parameters, completion: { (result) -> Void in
            var list = [T]()
            for (_, subjson) in result {
                list.append(T(opt1: subjson))
            }
            
            completion(list)
        }, errcompletion : { (result) -> Void in
            errcompletion(result)
        })
    }
    
    func getRequestObject<T:Initable>(_ url:String, paramaters: [String: AnyObject], completion: @escaping (_ result: T) -> Void, errcompletion: @escaping (_ result: String) -> Void){
        
        getRequest(url, parameters: paramaters, completion: {(result) -> Void in
            completion(T(opt1: result))
        }, errcompletion : { (result) -> Void in
            errcompletion(result)
        })
    }
    
    
    func deleteRequestObject<T:Initable>(_ url:String, parameters: [String: AnyObject], completion: @escaping (_ result: T) -> Void){
        
        deleteRequest(url, parameters: parameters) { (result) -> Void in
            completion(T(opt1: result))
        }
    }
    
    func postRequestObject<T:Initable>(_ url: String, paramters: [String: AnyObject], completion: @escaping (_ result: T) -> Void) {
        print(url)
        print(paramters)
        postRequest(url,parameters: paramters){ (result) -> Void in
            print(result)
            completion(T(opt1: result))
        }
    }
    
    func getRequestArrays<T:Initable>(_ url:String, parameters: [String: AnyObject], jsonKey: String, completion: @escaping (_ result: [T]) -> Void, errcompletion: @escaping (_ result: String) -> Void){
        
        getRequest(url, parameters: parameters, completion:  { (result) -> Void in
            var list = [T]()
            for (_, subjson) in result[jsonKey] {
                list.append(T(opt1: subjson))
            }
            
            completion(list)
        }, errcompletion : { (result) -> Void in
            errcompletion(result)
        })
    }
}

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

class FtpManager : MaestroAPI{
    func getFtpList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetFtpAccounts"
        let params : [String: AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "name": dname as AnyObject
        ]
        
        getRequestArrays(url, parameters : params, completion: { (result:
            [FtpListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
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

class DNSManager: MaestroAPI {
    func getDNSRecords(_ dname: String, completion: @escaping (_ result: DNSRecordsModel) -> Void, errcompletion: @escaping (_ result: String)-> Void){
        
        let url : String = "Domain/GetDnsRecords"
        let params : [String: AnyObject] = [
            "key":apiKey as AnyObject,
            "format":"json" as AnyObject,
            "name": dname as AnyObject
        ]
        
        getRequestObject(url, paramaters: params, completion: {
            (result: DNSRecordsModel) -> Void in
            completion(result)
        }, errcompletion: errcompletion)
        
    }
    
    func deleteDNSRecord(_ dname: String, rectype: String, recname: String, recvalue: String, priority: Int64, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "Domain/DeleteDnsRecord?format=json"
        let params : [String: AnyObject] = [
            "key":apiKey as AnyObject,
            "name": dname as AnyObject,
            "rec_type":rectype as AnyObject,
            "rec_name":recname as AnyObject,
            "rec_value":recvalue as AnyObject,
            "priority":Int(priority) as AnyObject
        ]
        
        postRequestObject(url, paramters: params, completion: {
            (result: OperationResult) -> Void in
            completion(result)
        })
    }
    
    func addDnsRecord(_ dname: String, rectype: String, recname: String, recvalue: String, priority: Int64, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "Domain/AddDnsRecord?format=json"
        
        let parameters : [String:AnyObject] = [
        "key":apiKey as AnyObject,
        "name": dname as AnyObject,
        "rec_type":rectype as AnyObject,
        "rec_name":recname as AnyObject,
        "rec_value":recvalue as AnyObject,
        "priority":Int(priority) as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
}

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
}
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



