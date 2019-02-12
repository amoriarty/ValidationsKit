//
//  OptionalType.swift
//  Validation
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

/// Capable of being represented by an optional wrapped type.
///
/// This protocol mostly exists to allow constrained extensions on generic type
/// where an assiociatedtype is an `Optional<T>`
public protocol OptionalType {

    /// Underlying wrapped type
    associatedtype WrappedType

}

/// Conform concrete optional to `OptionalType`
/// See `OptionalType` for more information.
extension Optional: OptionalType {

    /// See `OptionalType.WrappedType`
    public typealias WrappedType = Wrapped

}
