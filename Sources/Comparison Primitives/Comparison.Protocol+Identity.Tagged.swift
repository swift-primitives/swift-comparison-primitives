// Comparison.Protocol+Identity.Tagged.swift
// Comparison.Protocol conformance for Tagged types.

public import Identity_Primitives

extension Tagged: Comparison.`Protocol` where Tag: ~Copyable, RawValue: ~Copyable & Comparison.`Protocol` {
    /// Returns whether the left-hand side tagged value is less than the right-hand side.
    ///
    /// Compares the underlying raw values using `Comparison.Protocol` semantics,
    /// enabling ordering comparison for `~Copyable` raw values without consuming them.
    ///
    /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Comparable` when RawValue
    ///   conforms to both. This ensures Copyable types use the standard library operator.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Tagged, rhs: borrowing Tagged) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
