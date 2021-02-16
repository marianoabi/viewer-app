//
//  ItemsTableViewCell.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

// MARK: - Properties/Overrides
class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var attribute1Key: LabelPrimaryBold!
    @IBOutlet weak var attribute1Value: LabelPrimaryRegular!
    @IBOutlet weak var attribute2Key: LabelPrimaryBold!
    @IBOutlet weak var attribute2Value: LabelPrimaryRegular!
    
    @IBOutlet weak var backgroundView1: UIView!
    @IBOutlet weak var backgroundView2: UIView!
    
    override var backgroundColor: UIColor? {
        didSet {
            backgroundView1.backgroundColor = backgroundColor
            backgroundView2.backgroundColor = backgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Functions/Methods
extension ItemTableViewCell {
    func updateData(item: Any) {
        if let item = item as? PDF {
            
            self.attribute1Key.text = "Filename:"
            self.attribute1Value.text = item.fileName
            
            self.attribute1Key.text = "Description"
            self.attribute2Value.text = item.description
            
        } else if let item = item as? Image {
            
            self.attribute1Key.text = "Author:"
            self.attribute1Value.text = item.author
            
            self.attribute2Key.text = "URL:"
            self.attribute2Value.text = item.url
        }
    }
}
