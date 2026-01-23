// Comparison.Protocol+Swift.UnsafeMutablePointer.swift
// Conditional conformance for UnsafeMutablePointer.

extension UnsafeMutablePointer: Comparison.`Protocol` {
    /// Returns whether the left-hand side pointer address is less than the right-hand side.
    ///
    /// - Note: Uses `copy` to copy the borrowed pointer values, converts to
    ///   `UnsafeRawPointer`, then compares via `Int(bitPattern:)`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` address is less than `rhs` address.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        let lhsCopy = copy lhs
        let rhsCopy = copy rhs
        return unsafe Int(bitPattern: UnsafeRawPointer(lhsCopy)) < Int(bitPattern: UnsafeRawPointer(rhsCopy))
    }
}
