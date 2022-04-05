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
/// You can customize the appearance of those views when creating using one of the provided init.
public struct ResponderNavigatorView<Responder, BackButton, NextButton, CloseButton>: View
where Responder: Hashable & CaseIterable, BackButton: View, NextButton: View, CloseButton: View {

    @ResponderState.Binding private var responder: Responder?
    private let backButton: BackButton
    private let nextButton: NextButton
    private let closeButton: CloseButton

    private let allCases = Array(Responder.allCases)

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// Only required parameter is `responder`.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - backButton: The back button; omitting this will show a backward chevron system image.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    ///   - closeButton: The close button. Omitting this will show a simple Text with "Close".
    public init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder nextButton: () -> NextButton,
        @ViewBuilder closeButton: () -> CloseButton
    ) {
        _responder = responder
        self.backButton = backButton()
        self.nextButton = nextButton()
        self.closeButton = closeButton()
    }

    public var body: some View {
        HStack(spacing: 16) {
            Button(action: goPrevious) {
                backButton
            }
            .disabled(currentIndex.map { $0 == .zero } ?? true)
            Button(action: goNext) {
                nextButton
            }
            .disabled(currentIndex.map { $0 == Responder.allCases.count - 1 } ?? true)
            Spacer()
            Button(action: { responder = nil }) {
                closeButton
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var currentIndex: Int? {
        guard let responder = responder else { return nil }
        return allCases.firstIndex(of: responder)
    }

    private func goNext() {
        guard let index = currentIndex else { return }
        responder = allCases[index + 1]
    }

    private func goPrevious() {
        guard let index = currentIndex else { return }
        responder = allCases[index - 1]
    }

}

public extension ResponderNavigatorView {

    private static var defaultBack: Image { .init(systemName: "chevron.backward") }
    private static var defaultNext: Image { .init(systemName: "chevron.forward") }
    private static var defaultClose: Text { .init("Close") }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init use all default views.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    init(responder: ResponderState<Responder?>.Binding) where BackButton == Image, NextButton == Image, CloseButton == Text {
        _responder = responder
        self.backButton = Self.defaultBack
        self.nextButton = Self.defaultNext
        self.closeButton = Self.defaultClose
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
    ) where BackButton == Image {
        _responder = responder
        self.backButton = Self.defaultBack
        self.nextButton = nextButton()
        self.closeButton = closeButton()
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
    ) where NextButton == Image {
        _responder = responder
        self.backButton = backButton()
        self.nextButton = Self.defaultNext
        self.closeButton = closeButton()
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
    ) where CloseButton == Text {
        _responder = responder
        self.backButton = backButton()
        self.nextButton = nextButton()
        self.closeButton = Self.defaultClose
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
    ) where NextButton == Image, CloseButton == Text {
        _responder = responder
        self.backButton = backButton()
        self.nextButton = Self.defaultNext
        self.closeButton = Self.defaultClose
    }

    /// Creates a navigator view with the given responder binding and control views.
    ///
    /// See ``init(responder:backButton:nextButton:closeButton:)``.
    ///
    /// This init shows default back and close buttons.
    /// - Parameters:
    ///   - responder: The ``ResponderState/Binding`` property that this view can change.
    ///   - nextButton: The next button; omitting this will show a forward chevron system image.
    init(
        responder: ResponderState<Responder?>.Binding,
        @ViewBuilder nextButton: () -> NextButton
    ) where BackButton == Image, CloseButton == Text {
        _responder = responder
        self.backButton = Self.defaultBack
        self.nextButton = nextButton()
        self.closeButton = Self.defaultClose
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
    ) where BackButton == Image, NextButton == Image {
        _responder = responder
        self.backButton = Self.defaultBack
        self.nextButton = Self.defaultNext
        self.closeButton = closeButton()
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
