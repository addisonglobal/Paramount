//
//  Toolbar.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class Toolbar: UIView {
    public private(set) var actionItem: ToolbarItem!
    public private(set) var closeItem: ToolbarItem!

    var dragHandle: UIView!
    var dragHandleImageView: UIImageView!
    var stackView: UIStackView!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        dragHandle = UIView()
        dragHandle.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        addSubview(dragHandle)

        dragHandleImageView = UIImageView(image: UIImage.make(name: "drag_handle"))
        dragHandle.addSubview(dragHandleImageView)

        actionItem = ToolbarItem.make(title: "action", image: UIImage.make(name: "action"))
        closeItem = ToolbarItem.make(title: "close", image: UIImage.make(name: "close"))

        stackView = UIStackView(arrangedSubviews: [actionItem, closeItem])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)

        self.frame.size.width = Dimension.Handle.width + Dimension.ToolbarItem.width * CGFloat(stackView.arrangedSubviews.count)
        self.frame.size.height = Dimension.Toolbar.height

        setupContraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setupContraints() {
        // Drag Handle
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        dragHandle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dragHandle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dragHandle.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        dragHandle.widthAnchor.constraint(equalToConstant: Dimension.Handle.width).isActive = true

        dragHandleImageView.translatesAutoresizingMaskIntoConstraints = false
        dragHandleImageView.centerXAnchor.constraint(equalTo: dragHandle.centerXAnchor).isActive = true
        dragHandleImageView.centerYAnchor.constraint(equalTo: dragHandle.centerYAnchor).isActive = true

        // Items
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: dragHandle.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
}
