// Comparison.Protocol+Swift.KeyValuePairs.swift
// Conditional conformance for KeyValuePairs.

extension KeyValuePairs: Comparison.`Protocol` where Key: Comparison.`Protocol` & Copyable, Value: Comparison.`Protocol` & Copyable {
    /// Returns whether the left-hand side is lexicographically less than the right-hand side.
    ///
    /// Compares key-value pairs in order. Keys are compared first, then values
    /// if keys are equal.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` is lexicographically ordered before `rhs`.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for (l, r) in zip(lhs, rhs) {
            if l.key < r.key { return true }
            if r.key < l.key { return false }
            if l.value < r.value { return true }
            if r.value < l.value { return false }
        }
        return lhs.count < rhs.count
    }
}
