//
//  LabelPrimaryRegular.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

class LabelPrimaryRegular: UILabel {
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLabel()
    }

    func configureLabel() {
        self.font = UIFont(name: ViewerApp.Fonts.primaryRegular, size: self.font.pointSize)
        self.textColor = ViewerApp.Colors.content
    }
}
