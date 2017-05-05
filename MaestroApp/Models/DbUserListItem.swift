//
//  DbUserListItem.swift
//  MaestroApp
//
//  Created by Nadir on 05/05/17.
//  Copyright © 2017 nadir akdag. All rights reserved.
//

import SwiftyJSON

class DbUserListItemModel: NSObject,Initable {
    var Username : String?
    var Rights : String?
    
    
    required init(opt1:JSON) {
        self.Username = opt1["Username"].stringValue
        self.Rights = opt1["Rights"].stringValue
    }
}
