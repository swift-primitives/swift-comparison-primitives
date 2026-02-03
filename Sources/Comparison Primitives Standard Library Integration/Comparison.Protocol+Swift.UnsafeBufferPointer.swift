// Comparison.Protocol+Swift.UnsafeBufferPointer.swift
// Conditional conformance for UnsafeBufferPointer.

extension UnsafeBufferPointer: Comparison.`Protocol` {
    /// Returns whether the left-hand side buffer pointer is less than the right-hand side.
    ///
    /// Compares base addresses first, then counts if addresses are equal.
    ///
    /// - Note: Uses `copy` to copy the borrowed buffer pointer values, then compares
    ///   base addresses via `Int(bitPattern:)`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    /// - Returns: `true` if `lhs` is ordered before `rhs`.
    @inlinable
    @_disfavoredOverload
    public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        let lhsCopy = copy lhs
        let rhsCopy = copy rhs
        let lhsAddr = unsafe lhsCopy.baseAddress.map { Int(bitPattern: $0) } ?? 0
        let rhsAddr = unsafe rhsCopy.baseAddress.map { Int(bitPattern: $0) } ?? 0
        if lhsAddr != rhsAddr { return lhsAddr < rhsAddr }
        return lhsCopy.count < rhsCopy.count
    }
}
