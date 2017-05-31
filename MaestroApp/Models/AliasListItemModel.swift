import Foundation
import SwiftyJSON

class AliasListItemModel: Initable {
    var Name : String?
    
    required init(opt1:JSON) {
        self.Name = opt1.stringValue
    }
}
