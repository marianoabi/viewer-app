//
//  ItemsTableViewCell.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var fileNameLabel: LabelPrimaryRegular!
    @IBOutlet weak var descriptionLabel: LabelPrimaryRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ItemTableViewCell {
    func updateData(item: Any) {
        if let item = item as? PDF {
            self.fileNameLabel.text = item.fileName
            self.descriptionLabel.text = item.description
        }
        
    }
}
