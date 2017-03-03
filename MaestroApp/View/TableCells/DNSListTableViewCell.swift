//
//  DNSListTableViewCell.swift
//  MaestroPanel
//


import UIKit

class DNSListTableViewCell: UITableViewCell {

    @IBOutlet weak var LblRecordType: UILabel!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LblValue: UILabel!
    @IBOutlet weak var LblPriority: UILabel!
    
    // Static Text
    @IBOutlet weak var LblIsim: UILabel!
    @IBOutlet weak var LblHost: UILabel!
    
    // Status Image
    @IBOutlet weak var LblTypeImage: UIImageView!
    
}
