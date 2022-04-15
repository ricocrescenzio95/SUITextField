//
//  FormatPolicy.swift
//  
//
//  Created by Rico Crescenzio on 15/04/22.
//

import Foundation

/// Indicates when the bound value is updated on a ``SUITextField`` with format/formatter.
///
/// Policy can specify when the conversion is made, either during typing or when text field did end editing.
public enum FormatPolicy {
    
    /// Parses the text to bound value on every text insertion.
    case onChange
    
    /// Parses the text to bound value when text field end editing.
    case onCommit
}
