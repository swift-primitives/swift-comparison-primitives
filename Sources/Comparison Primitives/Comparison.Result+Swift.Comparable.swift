// Comparison.Result+Swift.Comparable.swift
// Bridge for Swift.Comparable types.

extension Comparison.Result {
    /// Creates a comparison result from two `Swift.Comparable` values.
    ///
    /// This initializer bridges `Swift.Comparable` types to `Comparison.Result`,
    /// enabling use with standard library types like `Int`, `String`, and `Double`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison.Result(comparing: 5, to: 10)
    /// print(result)  // less
    ///
    /// let equal = Comparison.Result(comparing: "hello", to: "hello")
    /// print(equal)   // equal
    /// ```
    ///
    /// ## Distinction from Protocol-Based Initializer
    ///
    /// Use this initializer for `Swift.Comparable` types. For types conforming
    /// to `Comparison.Protocol` (including `~Copyable` types), use
    /// `init(_:_:)` instead.
    @inlinable
    public init<T: Swift.Comparable>(comparing lhs: T, to rhs: T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
}
