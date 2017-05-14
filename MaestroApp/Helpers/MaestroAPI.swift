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
        if preferences.object(forKey: apiKeyObjectKey) == nil {
            return "1_e547c39d90024967b3098379872a527c"
        } else {
            return preferences.string(forKey: apiKeyObjectKey)!
        }
    }
    
    var apiUrl : String  {
        if preferences.object(forKey: apiUrlObjectKey) == nil {
            return "http://panel.nadirakdag.xyz:9715/Api/v1/"
        } else {
            return preferences.string(forKey: apiUrlObjectKey)!
        }
    }
    
    func getRequest(_ url: String, parameters: [String: AnyObject], completion: @escaping (_ result: JSON) -> Void) {
        print(parameters)
        print(url)
        let headers: HTTPHeaders = [ "Accept-Language": "tr-tr" ]
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
            .responseJSON { response in
            
            if let json = response.result.value {
                let obj : BaseModel = BaseModel(opt1: JSON(json))
                
                if obj.ErrorCode == -1 {
                    
                }
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
        Alamofire.request(url, method: .delete, parameters: parameters).responseJSON{ response in
            if let json = response.result.value {
                print(url)
                print(json)
                completion(JSON(json)["Details"])
            }
        }
    }
    
    func postRequest(_ url: String, parameters: [String:AnyObject], completion: @escaping (_ result: JSON) -> Void){
        print(parameters)
        Alamofire.request( url, method: .post,parameters: parameters)
        .responseJSON{ response in
            if let json = response.result.value {
                print(json)
                completion(JSON(json)["Details"])
            }
        }
    }
    
    
    func getRequestArrays<T:Initable>(_ url:String, parameters: [String: AnyObject], completion: @escaping (_ result: [T]) -> Void){
        
        getRequest(url, parameters: parameters) { (result) -> Void in
            var list = [T]()
            for (_, subjson) in result {
                list.append(T(opt1: subjson))
            }
            
            completion(list)
        }
    }
    
    func getRequestObject<T:Initable>(_ url:String, paramaters: [String: AnyObject], completion: @escaping (_ result: T) -> Void){
        
        getRequest(url, parameters: paramaters) { (result) -> Void in
            completion(T(opt1: result))
        }
    }
    
    
    func deleteRequestObject<T:Initable>(_ url:String, parameters: [String: AnyObject], completion: @escaping (_ result: T) -> Void){
        
        deleteRequest(url, parameters: parameters) { (result) -> Void in
            completion(T(opt1: result))
        }
    }
    
    func postRequestObject<T:Initable>(_ url: String, paramters: [String: AnyObject], completion: @escaping (_ result: T) -> Void) {
        postRequest(url,parameters: paramters){ (result) -> Void in
            completion(T(opt1: result))
        }
    }
    
    func getRequestArrays<T:Initable>(_ url:String, parameters: [String: AnyObject], jsonKey: String, completion: @escaping (_ result: [T]) -> Void){
        
        getRequest(url, parameters: parameters) { (result) -> Void in
            var list = [T]()
            for (_, subjson) in result[jsonKey] {
                list.append(T(opt1: subjson))
            }
            
            completion(list)
        }
    }
}

class DomainManager : MaestroAPI{
    func getHostingDetail(_ dname: String, completion: @escaping (_ result: DomainListItemModel)-> Void)  {
        
        let url : String = "\(apiUrl)Domain/GetListItem"
        getRequestObject(url, paramaters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject],completion: completion)
    }
    
    func getDomainList(_ isReseller: Bool, resellerUserName : String?, completion: @escaping (_ result:NSMutableArray) -> Void){
        
        let url : String = "\(apiUrl)\(isReseller ? "Reseller/GetDomains":"Domain/GetList")"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "username": resellerUserName as AnyObject
        ]
        
        getRequestArrays(url, parameters: params) { (result: [DomainListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    
    func addDomain(_ dname: String, username: String, password: String, activiteDomainUser: Bool, firstName: String, lastName: String, email: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "\(apiUrl)Domain/create?format=json"
        let parameters : [String:AnyObject] =
            [
                "key":apiKey as AnyObject,
                "name": dname as AnyObject,
                "planAlias": "default" as AnyObject,
                "username": username as AnyObject,
                "password":password as AnyObject,
                "activedomainuser":(activiteDomainUser as Bool) as AnyObject,
                "firstname": firstName as AnyObject,
                "lastname": lastName as AnyObject,
                "email": email as AnyObject
        ]
    
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func changePassword(_ dname: String, newPass: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Domain/Password?format=json"
        let parameters : [String: AnyObject] = ["key":apiKey as AnyObject, "name": dname as AnyObject, "newpassword": newPass as AnyObject]
        
        postRequestObject(url, paramters: parameters){ (result:OperationResult) -> Void in
            completion(result)
        }
    }
    
    func deleteDomain(_ isReseller: Bool, userName: String, dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "\(apiUrl)\(isReseller ? "Reseller/DeleteDomain" : "Domain/Delete")"
        
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
        
        let url : String = "\(apiUrl)Domain/start?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "name": dname as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func stopDomain(_ dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "\(apiUrl)Domain/stop?format=JSON"
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
    func getDatabaseList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetDatabaseList"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject]) { (result:
            [DatabaseListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    func deleteDatabase(_ dname: String, database: String,dbtype: String, completion: @escaping (_ result: OperationResult) -> Void) {
        
        let url : String = "\(apiUrl)Domain/DeleteDatabase?format=json"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "name":dname as AnyObject, "dbtype": dbtype as AnyObject,"database":database as AnyObject]){
                (result: OperationResult) -> Void in
                    completion(result)
        }
    }
    
    func createDatabase(_ dname: String, dbType: String, database: String, userName: String, password: String, quota: Int, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Domain/AddDatabase?format=json"
        let parameters : [String:AnyObject] = ["key": apiKey as AnyObject, "name":dname as AnyObject, "dbtype": dbType as AnyObject,"database":database as AnyObject,"username":userName as AnyObject,"password": password as AnyObject,"quota": quota as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
                completion(result)
        }
    }
    
    func addDatabaseUser(_ dname: String, dbType: String, database: String, userName: String, password: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Domain/AddDatabaseUser?format=json"
        
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
        
        let url : String = "\(apiUrl)Domain/DeleteDatabaseUser?format=json"
        
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
        
        let url : String = "\(apiUrl)Domain/ChangeDatabaseUserPassword?format=json"
        
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
    func getAliasList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetDomainAliases"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject]) { (result:
            [AliasListItemModel]) -> Void in
            print(result)
            completion(NSMutableArray(array: result))
        }
    }
    
    func deleteAlias(_ dname: String, alias: String, completion: @escaping (_ result:OperationResult)-> Void){
        
        let url : String = "\(apiUrl)Domain/DeleteDomainAlias"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject, "alias":alias as AnyObject]) { (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addAlias(_ dname: String, alias: String, completion: @escaping (_ result:OperationResult)-> Void) {
        
        let url : String = "\(apiUrl)Domain/AddDomainAlias?format=json"
        let parameters : [String:AnyObject] = ["key": apiKey as AnyObject, "name": dname as AnyObject, "alias": alias as AnyObject]

        postRequestObject(url, paramters: parameters){
            (result: OperationResult) in
            completion(result)
        }
        
    }
}


class MailManager : MaestroAPI{
    func getMailList(_ dname: String, completion: @escaping (_ result:MailListModel) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetMailList"
        getRequestObject(url, paramaters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject]) { (result:
            MailListModel) -> Void in
            completion(result)
        }
    }
    
    func deleteMailbox(_ dname: String, account: String, completion: @escaping (_ result:OperationResult)->Void) {
        
        let url : String = "\(apiUrl)Domain/DeleteMailbox?format=json"
        postRequestObject(url, paramters: ["key": apiKey as AnyObject,  "name": dname as AnyObject, "account": account as AnyObject]){
            (result:OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addMailbox(_ dname: String, account: String, password: String, quota: Int, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url: String = "\(apiUrl)Domain/AddMailBox?format=json"
        
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
        
        let url: String = "\(apiUrl)Domain/ChangeMailBoxQuota?format=json"
        
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
        
        let url: String = "\(apiUrl)Domain/ChangeMailBoxPassword?format=json"
        
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
    func getSubdomainList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetSubDomains"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject]) { (result:
            [SubdomainListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    func deleteSubdomain(_ dname: String, subdomain: String, completion: @escaping (_ result:OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Domain/DeleteSubDomain"
        deleteRequestObject(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject, "subdomain": subdomain as AnyObject]){
            (result: OperationResult) -> Void in
                completion(result)
        }
    }
    
    func addSubDomain(_ dname: String, subDomain: String, ftpUser: String, completion: @escaping (_ result:OperationResult)-> Void){
        
        let url : String = "\(apiUrl)Domain/AddSubDomain?format=json"
        let parameters : [String:AnyObject] = ["name":dname as AnyObject, "subdomain":subDomain as AnyObject,"ftpuser":ftpUser as AnyObject,"key":apiKey as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result:OperationResult) in
            completion(result)
        }
    }
}

class FtpManager : MaestroAPI{
    func getFtpList(_ dname: String, completion: @escaping (_ result:NSMutableArray) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetFtpAccounts"
        getRequestArrays(url, parameters : ["key": apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject], jsonKey: "Users") { (result:
            [FtpListItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    func deleteFtpAccount(_ dname: String, account: String, completion: @escaping (_ result:OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Domain/DeleteFtpAccount?format=json"
        postRequestObject(url, paramters: ["key": apiKey as AnyObject, "name": dname as AnyObject, "account": account as AnyObject]){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addFtpAccount(_ dname: String, account: String, password: String, readOnly: Bool, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "\(apiUrl)Domain/AddFtpAccount?format=json"
        let parameters: [String:AnyObject] = ["key":apiKey as AnyObject, "name":dname as AnyObject, "account":account as AnyObject,"password":password as AnyObject,"homePath":"\\" as AnyObject,"ronly":String(readOnly) as AnyObject]
        
        postRequestObject(url, paramters: parameters){ (result: OperationResult) in
            completion(result)
        }
        
    }
    
    func ChangePasswordOfFtpAccount(_ dname: String, account: String, password: String, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "\(apiUrl)Domain/ChangeFtpPassword?format=json"
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
    func getDNSRecords(_ dname: String, completion: @escaping (_ result: DNSRecordsModel) -> Void){
        
        let url : String = "\(apiUrl)Domain/GetDnsRecords"
        getRequestObject(url, paramaters: ["key":apiKey as AnyObject, "format":"json" as AnyObject, "name": dname as AnyObject]){
            (result: DNSRecordsModel) -> Void in
            completion(result)
        }
        
    }
    
    func deleteDNSRecord(_ dname: String, rectype: String, recname: String, recvalue: String, priority: Int64, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "\(apiUrl)Domain/DeleteDnsRecord?format=json"
        postRequestObject(url, paramters: ["key":apiKey as AnyObject, "name": dname as AnyObject,"rec_type":rectype as AnyObject,"rec_name":recname as AnyObject,"rec_value":recvalue as AnyObject,"priority":Int(priority) as AnyObject]){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func addDnsRecord(_ dname: String, rectype: String, recname: String, recvalue: String, priority: Int64, completion: @escaping (_ result: OperationResult)->Void){
        
        let url : String = "\(apiUrl)Domain/AddDnsRecord?format=json"
        
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
    func getResellerList(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        let url : String = "\(apiUrl)Reseller/GetResellers"
        getRequestArrays(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject]){
            (result: [ResellerListItemModel]) in completion(NSMutableArray(array: result))
        }
    }
    
    func changePassword(_ username: String, newPass: String, completion: @escaping (_ result: OperationResult) -> Void){
        
        let url : String = "\(apiUrl)Reseller/Password?format=json"
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
        
        let url : String = "\(apiUrl)Reseller/Delete?format=JSON"
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
        
        let url : String = "\(apiUrl)Reseller/start?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "username": username as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func stopReseller(_ dname: String, completion: @escaping (_ result: OperationResult)-> Void){
        
        let url : String = "\(apiUrl)Reseller/stop?format=JSON"
        let parameters : [String:AnyObject] = [
            "key":apiKey as AnyObject,
            "username": dname as AnyObject]
        
        postRequestObject(url, paramters: parameters){
            (result: OperationResult) -> Void in
            completion(result)
        }
    }
    
    func getIpAddresses(_ userName: String, completion: @escaping (_ result: NSMutableArray) -> Void) {
        let url : String = "\(apiUrl)/Reseller/GetIPAddrList"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject,
            "username" : userName as AnyObject
        ]
        
        getRequestArrays(url, parameters: params) { (result: [ServerResourceItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
}
class ServerManager : MaestroAPI {
    
    func getServerList(_ completion: @escaping (_ result: NSMutableArray) -> Void) {
        
        let url : String = "\(apiUrl)/Server/GetServerList"
        getRequestArrays(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject]) { (result: [ServerListItemModel]) in
            completion(NSMutableArray(array: result))
        }
    }
    
    func getServerResources(_ serverName: String,completion: @escaping (_ result: NSMutableArray) -> Void) {
        let url : String = "\(apiUrl)/Server/GetResources"
        getRequestArrays(url, parameters: ["key": apiKey as AnyObject, "format":"json" as AnyObject, "servername": serverName as AnyObject]) { (result: [ServerResourceItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    func getIpAddresses(_ completion: @escaping (_ result: NSMutableArray) -> Void) {
        let url : String = "\(apiUrl)/Server/GetIpAddrList"
        let params : [String:AnyObject] = [
            "key": apiKey as AnyObject,
            "format":"json" as AnyObject
        ]
        
        getRequestArrays(url, parameters: params) { (result: [ServerResourceItemModel]) -> Void in
            completion(NSMutableArray(array: result))
        }
    }
    
    func addIpAddrres(_ serverName: String,nicName : String, ipAddr: String, subNet:String, isShared:Bool, isDedicated:Bool, isExclusive:Bool, completion: @escaping (_ result: OperationResult) -> Void) {
        let url : String = "\(apiUrl)/Server/AddIpAddr"
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
        let url : String = "\(apiUrl)/Server/DeleteIpAddr"
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



