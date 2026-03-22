// Comparison.Protocol+Swift.UnsafeMutableRawPointer.swift
// Conformance for UnsafeMutableRawPointer.

extension UnsafeMutableRawPointer: Comparison.`Protocol` {
    /// Returns whether the left-hand side pointer address is less than the right-hand side.
    ///
    /// - Note: Uses `copy` to copy the borrowed pointer values, then compares
    ///   via `Int(bitPattern:)`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` address is less than `rhs` address.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        let lhsCopy = unsafe copy lhs
        let rhsCopy = unsafe copy rhs
        return Int(bitPattern: lhsCopy) < Int(bitPattern: rhsCopy)
    }
}
