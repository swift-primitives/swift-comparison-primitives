// Comparison.Protocol+Swift.ContiguousArray.swift
// Conditional conformance for ContiguousArray.

extension ContiguousArray: Comparison.`Protocol` where Element: Comparison.`Protocol` {
    /// Returns whether the left-hand side is lexicographically less than the right-hand side.
    ///
    /// Compares arrays element-by-element. If all compared elements are equal,
    /// the shorter array is considered less than the longer one.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` is lexicographically ordered before `rhs`.
    @inlinable
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for (l, r) in zip(lhs, rhs) {
            if l < r { return true }
            if r < l { return false }
        }
        return lhs.count < rhs.count
    }
}
