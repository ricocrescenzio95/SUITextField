//
//  CharacterReplacement.swift
//  
//
//  Created by Rico Crescenzio on 07/04/22.
//

import Foundation

/// Contains all info after a replacement triggered by ``SUITextField/shouldChangeCharacters(_:)``.
public struct CharacterReplacement: Hashable {

    /// The origin string of the replacement.
    public let originString: String

    /// The new string, generated after applying ``replacementString`` to ``originString``
    /// at the specified ``range``.
    public let newString: String

    /// The range where ``replacementString`` will be applied to ``originString``.
    public let range: NSRange

    /// The text that is inserted into the text field.
    public let replacementString: String

}
