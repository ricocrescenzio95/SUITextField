//
//  _SUITextField.swift
//  
//
//  Created by Rico Crescenzio on 02/04/22.
//

import Combine
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

    var controller: UIHostingController<Content>?
    private var cancellable: AnyCancellable?

    var rootView: Content? {
        get { controller?.rootView }
        set {
            guard let newValue = newValue else { return }
            controller?.rootView = newValue
            layoutContent()
        }
    }

    var allowSelfSizing = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = view as! UIInputView
        view.allowsSelfSizing = allowSelfSizing

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

        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardDidChangeFrameNotification)
            .sink { [weak self] _ in
                self?.layoutContent()
            }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [weak self] _ in
            self?.layoutContent()
        }
    }

    private func layoutContent() {
        controller?.view.invalidateIntrinsicContentSize()
        view.invalidateIntrinsicContentSize()
        view.layoutIfNeeded()
    }

}
