//
//  LogCell.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import UIKit

class LogCell: UITableViewCell {
  
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 12.25
    }
    
    func update(_ log: Log) {
        content.text = log.content
    
        colorView.backgroundColor = log.type.color
    }
}
