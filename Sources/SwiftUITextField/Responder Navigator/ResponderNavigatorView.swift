//
//  ResponderNavigatorView.swift
//  
//
//  Created by Rico Crescenzio on 05/04/22.
//

import SwiftUI

/// A view containing controls to navigate through responders and to resign first responder.
///
/// You typically set this view as ``SUITextField/inputAccessoryView(view:)`` to show it on top of the keyboard.
/// By default it shows you 2 buttons to navigate backward/forward and a close button to dismiss the keyboard.
///
/// ![Example image](responder-view)
///
/// You can customize the appearance of those views when creating using one of the provided init.
///
/// To apply a center view, use the ``centerView(view:)`` modifier instead.
public struct ResponderNavigatorView<Responder, BackButton, NextButton, CenterView, CloseButton>: View
where Responder: Hashable, BackButton: View, NextButton: View, CenterView: View, CloseButton: View {

    @ResponderState.Binding private var responder: Responder?
    private let backButton: BackButton
    private let nextButton: NextButton
    private let centerView: CenterView
    private let closeButton: CloseButton

    private let values: [Responder]

    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder centerView: () -> CenterView,
        @ViewBuilder closeButton: () -> CloseButton
    ) {
        _responder = responder
        self.values = values
        self.backButton = backButton()
        self.nextButton = nextButton()
        self.centerView = centerView()
        self.closeButton = closeButton()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// Only required parameter is `responder` and `values`.
    ///
    /// If your `Responder` type conforms to `CaseIterable`, see ``init(responder:backButton:nextButton:closeButton:)``.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    public init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where CenterView == EmptyView {
        self.init(
            responder: responder,
            values: values,
            backButton: backButton,
            nextButton: nextButton,
            centerView: { EmptyView() },
            closeButton: closeButton
        )
    }

    public var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 16) {
                Button(action: goPrevious) {
                    backButton
                }
                .disabled(currentIndex.map { $0 == .zero } ?? true)
                Button(action: goNext) {
                    nextButton
                }
                .disabled(currentIndex.map { $0 == values.count - 1 } ?? true)
            }
            Spacer()
            centerView
            Spacer()
            Button(action: { responder = nil }) {
                closeButton
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(minHeight: 44)
    }

    private var currentIndex: Int? {
        guard let responder = responder else { return nil }
        return values.firstIndex(of: responder)
    }

    private func goNext() {
        guard let index = currentIndex else { return }
        responder = values[index + 1]
    }

    private func goPrevious() {
        guard let index = currentIndex else { return }
        responder = values[index - 1]
    }

}

public extension ResponderNavigatorView {

    private static var defaultBack: Image {
        if #available(iOS 14, *) {
            return .init(systemName: "chevron.backward")
        } else {
            return .init(systemName: "arrow.left")
        }
    }

    private static var defaultNext: Image {
        if #available(iOS 14, *) {
            return .init(systemName: "chevron.forward")
        } else {
            return .init(systemName: "arrow.right")
        }
    }

    private static var defaultClose: Image { .init(systemName: "xmark") }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init use all default views.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    init(responder: ResponderState<Responder?>.Binding, values: [Responder])
    where BackButton == Image, NextButton == Image, CloseButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = Self.defaultBack
        self.nextButton = Self.defaultNext
        self.closeButton = Self.defaultClose
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default back button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where BackButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = Self.defaultBack
        self.nextButton = nextButton()
        self.closeButton = closeButton()
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where NextButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = backButton()
        self.nextButton = Self.defaultNext
        self.closeButton = closeButton()
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default close button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton
    ) where CloseButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = backButton()
        self.nextButton = nextButton()
        self.closeButton = Self.defaultClose
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next and close buttons.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder backButton: () -> BackButton
    ) where NextButton == Image, CloseButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = backButton()
        self.nextButton = Self.defaultNext
        self.closeButton = Self.defaultClose
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default back and close buttons.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder nextButton: () -> NextButton
    ) where BackButton == Image, CloseButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = Self.defaultBack
        self.nextButton = nextButton()
        self.closeButton = Self.defaultClose
        centerView = EmptyView()
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:values:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next and back button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        values: [Responder],
        @ViewBuilder closeButton: () -> CloseButton
    ) where BackButton == Image, NextButton == Image, CenterView == EmptyView {
        _responder = responder
        self.values = values
        self.backButton = Self.defaultBack
        self.nextButton = Self.defaultNext
        self.closeButton = closeButton()
        centerView = EmptyView()
    }

}

public extension ResponderNavigatorView where Responder: CaseIterable {

    /// Creates a navigator view with the given responder binding and control views.
    /// All possible values are automatically taken from `Responder.allCases`.
    ///
    /// Only required parameter is `responder`.
    ///
    /// For `Responder` types non conforming to `CaseIterable`, see ``init(responder:values:backButton:nextButton:closeButton:)``.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where CenterView == EmptyView {
        self.init(
            responder: responder,
            values: Array(Responder.allCases),
            backButton: backButton,
            nextButton: nextButton,
            centerView: { EmptyView() },
            closeButton: closeButton
        )
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init use all default views.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    init(responder: ResponderState<Responder?>.Binding)
    where BackButton == Image, NextButton == Image, CloseButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases))
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default back button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where BackButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), nextButton: nextButton, closeButton: closeButton)
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) where NextButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), backButton: backButton, closeButton: closeButton)
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default close button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton
    ) where CloseButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), backButton: backButton, nextButton: nextButton)
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next and close buttons.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder backButton: () -> BackButton
    ) where NextButton == Image, CloseButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), backButton: backButton)
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default back and close buttons.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - values: The array of values that should match against `responder` bound property.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder nextButton: () -> NextButton
    ) where BackButton == Image, CloseButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), nextButton: nextButton)
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default next and back button.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder closeButton: () -> CloseButton
    ) where BackButton == Image, NextButton == Image, CenterView == EmptyView {
        self.init(responder: responder, values: Array(Responder.allCases), closeButton: closeButton)
    }

}

public extension ResponderNavigatorView where CenterView == EmptyView {

    /// Add a custom view in the middle of the navigator view.
    ///
    /// - Parameter view: A `@ViewBuilder` returning the view to be placed in the center of navigator.
    /// - Returns: The modified view.
    func centerView<Content>(
        @ViewBuilder view: () -> Content
    ) -> ResponderNavigatorView<Responder, BackButton, NextButton, Content, CloseButton> where Content: View {
        ResponderNavigatorView<Responder, BackButton, NextButton, Content, CloseButton>(
            responder: _responder,
            values: values,
            backButton: { backButton },
            nextButton: { nextButton},
            centerView: view,
            closeButton: { closeButton }
        )
    }

}

struct ResponderNavigatorView_Previews: PreviewProvider {

    struct TestView: View {

        enum Fields: Hashable, CaseIterable {
            case username
            case password
        }

        @ResponderState private var responder: Fields?
        @State private var username = ""
        @State private var password = ""

        var body: some View {
            ScrollView {
                VStack {
                    SUITextField(text: $username)
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($responder, equals: .username)
                    SUITextField(text: $password)
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($responder, equals: .password)
                }
            }
            .uiTextFieldBorderStyle(.roundedRect)
        }

        private var navigator: some View {
            ResponderNavigatorView(responder: $responder)
        }

    }

    static var previews: some View {
        TestView()
    }

}
