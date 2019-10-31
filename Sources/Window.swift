//
//  Window.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class Window: UIWindow {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        windowLevel = UIWindow.Level.statusBar + 100
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var pointInside = false

            if let viewController = rootViewController as? ViewController,
                viewController.shouldReceiveTouch(windowPoint: point) {
                pointInside = super.point(inside: point, with: event)
        }

        return pointInside
    }
}
