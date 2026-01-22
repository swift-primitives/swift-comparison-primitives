// Comparison.Result+Comparable.swift
// Construction from Comparable types.

extension Comparison.Result {
    /// Creates a comparison result from two comparable values.
    ///
    /// Supports both `Copyable` and `~Copyable` types via `borrowing` parameters.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison.Result(5, 10)
    /// print(result)  // less
    ///
    /// let equal = Comparison.Result("hello", "hello")
    /// print(equal)   // equal
    /// ```
    ///
    /// ## Move-Only Support
    ///
    /// Works with `~Copyable` types:
    ///
    /// ```swift
    /// struct Token: ~Copyable, Comparison.Protocol {
    ///     let id: Int
    ///     static func < (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
    ///         lhs.id < rhs.id
    ///     }
    ///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
    ///         lhs.id == rhs.id
    ///     }
    /// }
    /// let result = Comparison.Result(token1, token2)
    /// ```
    @inlinable
    public init<T: Comparison.`Protocol` & ~Copyable>(_ lhs: borrowing T, _ rhs: borrowing T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
}
