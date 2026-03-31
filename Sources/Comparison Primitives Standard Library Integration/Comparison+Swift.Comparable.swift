// Comparison+Swift.Comparable.swift
// Bridge for Swift.Comparable types.

// MARK: - Comparison.Protocol Conformance for Integer Types

/// Conformance for `Int` to `Comparison.Protocol`.
extension Int: Comparison.`Protocol` {}

/// Conformance for `UInt` to `Comparison.Protocol`.
extension UInt: Comparison.`Protocol` {}

/// Conformance for `Int8` to `Comparison.Protocol`.
extension Int8: Comparison.`Protocol` {}

/// Conformance for `Int16` to `Comparison.Protocol`.
extension Int16: Comparison.`Protocol` {}

/// Conformance for `Int32` to `Comparison.Protocol`.
extension Int32: Comparison.`Protocol` {}

/// Conformance for `Int64` to `Comparison.Protocol`.
extension Int64: Comparison.`Protocol` {}

/// Conformance for `UInt8` to `Comparison.Protocol`.
extension UInt8: Comparison.`Protocol` {}

/// Conformance for `UInt16` to `Comparison.Protocol`.
extension UInt16: Comparison.`Protocol` {}

/// Conformance for `UInt32` to `Comparison.Protocol`.
extension UInt32: Comparison.`Protocol` {}

/// Conformance for `UInt64` to `Comparison.Protocol`.
extension UInt64: Comparison.`Protocol` {}

// MARK: - Comparison Initializer

extension Comparison {
    /// Creates a comparison result from two `Swift.Comparable` values.
    ///
    /// This initializer bridges `Swift.Comparable` types to `Comparison`,
    /// enabling use with standard library types like `Int`, `String`, and `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison(comparing: 5, to: 10)
    /// print(result)  // less
    ///
    /// let equal = Comparison(comparing: "hello", to: "hello")
    /// print(equal)   // equal
    /// ```
    ///
    /// ## Distinction from Protocol-Based Initializer
    ///
    /// Use this initializer for `Swift.Comparable` types. For types conforming
    /// to `Comparison.Protocol` (including `~Copyable` types), use
    /// `init(_:_:)` instead.
    // SE-0499: Swift.Comparable no longer implies Copyable in Swift 6.4.
    // The ~Copyable suppression + borrowing parameters let this init work
    // for both Copyable and ~Copyable Comparable types.
#if compiler(>=6.4)
    @inlinable
    @_disfavoredOverload
    public init<T: Swift.Comparable & ~Copyable>(comparing lhs: borrowing T, to rhs: borrowing T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
#else
    @inlinable
    @_disfavoredOverload
    public init<T: Swift.Comparable>(comparing lhs: T, to rhs: T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
#endif
}
