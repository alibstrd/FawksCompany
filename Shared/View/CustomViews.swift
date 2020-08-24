//
//  CustomButtom.swift
//  FawksCompany
//
//  Created by PHANTOM on 04/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

public class CustomButton: UIButton {
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

public class RoundedImageView: UIImageView {
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
}

public class RoundedShadowView: UIView {
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.FawksColor?.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
    }
}

public class RoundedShadowButton: UIButton {
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
    }
}
