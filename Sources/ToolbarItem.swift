//
//  ToolbarItem.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class ToolbarItem: UIButton {

    let color = UIColor(white: 1.0, alpha: 0.95)

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = color
        setTitleColor(.black, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    static func make(title: String, image: UIImage?) -> ToolbarItem {
        let item = ToolbarItem(type: .custom)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        item.setAttributedTitle(attributedString, for: .normal)
        item.setImage(image, for: .normal)

        return item
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        imageEdgeInsets = UIEdgeInsets(top: -10, left: 10, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.bounds.size.width/2, bottom: -30, right: 0)
    }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .gray : color
        }
    }
}
