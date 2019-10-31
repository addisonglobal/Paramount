//
//  ViewController.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {

    public var action: Action?
    public var close: Action?

    var toolbar: Toolbar!

    // Only valid while a toolbar drag pan gesture is in progress.
    var toolbarFrameBeforeDragging: CGRect = .zero

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
    }

    func setupToolbar() {
        toolbar = Toolbar()
        view.addSubview(toolbar)
        toolbar.frame.origin.y = 100

        toolbar.actionItem.addTarget(self, action: #selector(actionDidTouch), for: .touchUpInside)
        toolbar.closeItem.addTarget(self, action: #selector(closeDidTouch), for: .touchUpInside)

        let panGR = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(gr:)))
        toolbar.dragHandle.addGestureRecognizer(panGR)
    }

// MARK: - Action
    @objc func actionDidTouch() {
        action?()
    }

    @objc func closeDidTouch() {
        close?()
    }

  // MARK: - Gesture
    @objc func handlePanGesture(gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            toolbarFrameBeforeDragging = toolbar.frame
            updateToolbar(gr: gr)
        case .changed, .ended:
            updateToolbar(gr: gr)
        default:
            break
        }
    }

    func updateToolbar(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: view)

        var newToolbarFrame = toolbarFrameBeforeDragging
        newToolbarFrame.origin.y += translation.y
        newToolbarFrame.origin.x += translation.x

        let maxY = view.bounds.maxY - newToolbarFrame.size.height
        let maxX = view.bounds.maxX - toolbar.frame.size.width

        // X
        if newToolbarFrame.origin.x < 0.0 {
            newToolbarFrame.origin.x = 0.0
        } else if newToolbarFrame.origin.x > maxX {
            newToolbarFrame.origin.x = maxX
        }

        // Y
        if newToolbarFrame.origin.y < 0.0 {
            newToolbarFrame.origin.y = 0.0
        } else if newToolbarFrame.origin.y > maxY {
            newToolbarFrame.origin.y = maxY
        }

        toolbar.frame = newToolbarFrame
    }

    // MARK: - Touch
    public func shouldReceiveTouch(windowPoint point: CGPoint) -> Bool {
        var shouldReceiveTouch = false

        let pointInLocalCoordinates = view.convert(point, from: nil)

        // Always if it's on the toolbar
        if (toolbar.frame.contains(pointInLocalCoordinates)) {
          shouldReceiveTouch = true
        }

        return shouldReceiveTouch;
    }

// MARK: Status Bar Wrangling for iOS 7

  // Try to get the preferred status bar properties from the app's root view controller (not us).
  // In general, our window shouldn't be the key window when this view controller is asked about the status bar.
  // However, we guard against infinite recursion and provide a reasonable default for status bar behavior in case our window is the keyWindow.
    func viewControllerForStatusBarAndOrientationProperties() -> UIViewController? {
        guard var viewControllerToAsk = UIApplication.shared.keyWindow?.rootViewController
            else { return nil }

        // On iPhone, modal view controllers get asked
        if UIDevice.current.userInterfaceIdiom == .phone {
            while let vc = viewControllerToAsk.presentedViewController {
                viewControllerToAsk = vc
            }
        }

        return viewControllerToAsk
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties(), viewControllerToAsk != self
            else { return .default }

        // We might need to foward to a child
        if let childViewControllerToAsk = viewControllerToAsk.childForStatusBarStyle {
            return childViewControllerToAsk.preferredStatusBarStyle
        } else {
            return viewControllerToAsk.preferredStatusBarStyle
        }
    }

    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties(), viewControllerToAsk != self
            else { return .none }

        return viewControllerToAsk.preferredStatusBarUpdateAnimation
    }

    public override var prefersStatusBarHidden: Bool {
        guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties(),
            viewControllerToAsk != self else { return false }

        // We might need to foward to a child
        if let childViewControllerToAsk = viewControllerToAsk.childForStatusBarStyle {
            return childViewControllerToAsk.prefersStatusBarHidden
        } else {
            return viewControllerToAsk.prefersStatusBarHidden
        }
    }

  // MARK: - Rotation

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        var supportedOrientations = infoPlistSupportedInterfaceOrientationsMask()

        guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties(),
                viewControllerToAsk != self else { return supportedOrientations }

        supportedOrientations = viewControllerToAsk.supportedInterfaceOrientations

        // The UIViewController docs state that this method must not return zero.
        // If we weren't able to get a valid value for the supported interface orientations, default to all supported.
        //    if (supportedOrientations == 0) {
        //      supportedOrientations = .All;
        //    }

        return supportedOrientations
    }
    
    public override var shouldAutorotate: Bool {
        guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties(),
            viewControllerToAsk != self else { return false }

        return viewControllerToAsk.shouldAutorotate
    }

  // MARK: - Info
    func infoPlistSupportedInterfaceOrientationsMask() -> UIInterfaceOrientationMask {
        guard let supportedOrientations = Bundle.main.infoDictionary?["UISupportedInterfaceOrientations"] as? [String]
            else { return .portrait }

        var supportedOrientationsMask: UIInterfaceOrientationMask = [.portrait]

        let mapping: [String: UIInterfaceOrientationMask] = [
            "UIInterfaceOrientationPortrait": .portrait,
            "UIInterfaceOrientationMaskLandscapeRight": .landscapeRight,
            "UIInterfaceOrientationMaskPortraitUpsideDown": .portraitUpsideDown,
            "UIInterfaceOrientationLandscapeLeft": .landscapeLeft,
        ]

        mapping.forEach {
            if supportedOrientations.contains($0) {
                supportedOrientationsMask.insert($1)
            }
        }

        return supportedOrientationsMask
    }
}
