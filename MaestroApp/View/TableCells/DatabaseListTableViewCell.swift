//
//  DatabaseListTableViewCell.swift
//  MaestroPanel
//

import UIKit

class DatabaseListTableViewCell: UITableViewCell {

    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LblDiskQuota: UILabel!
    @IBOutlet weak var LblDiskUsage: UILabel!
    @IBOutlet weak var LblDbType : UILabel!
    
    // Static Text
    @IBOutlet weak var LblLimit: UILabel!
    @IBOutlet weak var LblBoyut: UILabel!
    
    // Status Image
    @IBOutlet weak var LblTur: UIImageView!

}
