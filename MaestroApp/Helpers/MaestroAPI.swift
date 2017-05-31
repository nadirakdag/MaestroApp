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








