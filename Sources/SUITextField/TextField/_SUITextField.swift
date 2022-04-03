//
//  _SUITextField.swift
//  
//
//  Created by Rico Crescenzio on 02/04/22.
//

import SwiftUI

/// Internal class that allows to edit the `inputViewController` and `inputAccessoryViewController`.
class _SUITextField: UITextField {

    var _inputViewController: UIInputViewController?
    var _inputAccessoryViewController: UIInputViewController?

    override var inputViewController: UIInputViewController? {
        get {
            _inputViewController
        }
        set { _inputViewController = newValue }
    }

    override var inputAccessoryViewController: UIInputViewController? {
        get {
            _inputAccessoryViewController
        }
        set { _inputAccessoryViewController = newValue }
    }

}

/// A custom Input view controller that wraps a `SwiftUI` hosting controller in order to display
/// either an input view or an input accessory view.
class SUIInputViewController<Content>: UIInputViewController where Content: View {

    var controller: HC<Content>?

    var rootView: Content? {
        get { controller?.rootView }
        set {
            guard let newValue = newValue else { return }
            controller?.rootView = newValue
            layoutContent()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = view as! UIInputView
        view.allowsSelfSizing = true
        
        view.translatesAutoresizingMaskIntoConstraints = false

        guard let controller = controller else { return }

        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(controller)
        view.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        controller.didMove(toParent: self)
    }

    private func layoutContent() {
        view.bounds.size = controller?.sizeThatFits(in: UIView.layoutFittingCompressedSize) ?? .zero
        controller?.view.invalidateIntrinsicContentSize()
        view.invalidateIntrinsicContentSize()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("did layout \(self)")
    }

    deinit {
        print("deinit \(self)")
    }

}

class HC<Content>: UIHostingController<Content> where Content: View {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("did layout \(self)")
    }

    deinit {
        print("deinit \(self)")
    }

}
