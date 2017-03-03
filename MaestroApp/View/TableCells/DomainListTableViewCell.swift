//
//  DomainListTableViewCell.swift
//  MaestroPanel
//

import UIKit

class DomainListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var LblDomainName: UILabel! 
    @IBOutlet weak var LblOwnerName: UILabel!
    @IBOutlet weak var LblExperationDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    
    // Static Text
    @IBOutlet weak var lblYetkili: UILabel!
    @IBOutlet weak var lblSonlanmaTarihi: UILabel!
    
    // Status Image
    @IBOutlet weak var LblStatusImage: UIImageView!

    
}
