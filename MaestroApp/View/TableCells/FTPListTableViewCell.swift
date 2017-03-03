//
//  FTPListTableViewCell.swift
//  MaestroPanel
//


import UIKit

class FTPListTableViewCell: UITableViewCell {

    @IBOutlet weak var LblUserName: UILabel!
    @IBOutlet weak var LblHomePath: UILabel!
    @IBOutlet weak var LblStatus: UILabel!
    @IBOutlet weak var LblReadOnly: UILabel!
    
    // Static Text
    @IBOutlet weak var LblGirisDizini: UILabel!
    @IBOutlet weak var LblOkumaYetki: UILabel!
    
    // Status Image
    @IBOutlet weak var LblStatusImage: UIImageView!

}
