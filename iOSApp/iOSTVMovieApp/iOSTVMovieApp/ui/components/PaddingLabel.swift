//
//  PaddingLabel.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 29/11/2025.
//


import UIKit

final class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + padding.left + padding.right,
            height: size.height + padding.top + padding.bottom
        )
    }
}
