//
//  DefaultAttributesMergePolicy.swift
//  
//
//  Created by Rico Crescenzio on 13/04/22.
//

/// Used in ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
/// to tell the modifier how to apply new attributes.
public enum DefaultAttributesMergePolicy {
    
    /// When two dict of attributes contains same key, old value is kept.
    case keepOld
    
    /// When two dict of attributes contains same key, new value is kept.
    case keepNew
    
    /// The old dict of attributes is completely removed in place of the new one.
    case rewriteAll
}
