// Comparison.Protocol+Swift.CollectionOfOne.swift
// Conditional conformance for CollectionOfOne.

extension CollectionOfOne: Comparison.`Protocol` where Element: Comparison.`Protocol` {
    /// Returns whether the left-hand side is less than the right-hand side.
    ///
    /// Compares the single element in each collection.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` is ordered before `rhs`.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs[lhs.startIndex] < rhs[rhs.startIndex]
    }
}
