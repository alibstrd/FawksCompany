//
//  CustomButtom.swift
//  FawksCompany
//
//  Created by PHANTOM on 04/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
}

class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.FawksColor?.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
    }
}

class RoundedShadowButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
    }
}
