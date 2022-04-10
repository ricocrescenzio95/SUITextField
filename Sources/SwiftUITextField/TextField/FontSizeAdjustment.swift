//
//  FontSizeAdjustment.swift
//  
//
//  Created by Rico Crescenzio on 10/04/22.
//

import UIKit

/// Tells the ``SUITextField`` whether or not to scale the font size
/// when the text fills its width.
///
/// See `uiTextFieldAdjustsFontSizeToFitWidth(_:)` view modifier.
public enum FontSizeWidthAdjustment {

    /// Font will not be scaled if it fills the ``SUITextField``.
    case disabled

    /// Font will be scaled if it fills the ``SUITextField`` until it reaches the `minSize` value.
    case enabled(minSize: CGFloat)
}
