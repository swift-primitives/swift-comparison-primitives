// Comparison.Protocol+Swift.ArraySlice.swift
// Conditional conformance for ArraySlice.

extension ArraySlice: Comparison.`Protocol` where Element: Comparison.`Protocol` {
    /// Returns whether the left-hand side is lexicographically less than the right-hand side.
    ///
    /// Compares slices element-by-element. If all compared elements are equal,
    /// the shorter slice is considered less than the longer one.
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
