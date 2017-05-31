import Foundation
import Alamofire
import SwiftyJSON


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
