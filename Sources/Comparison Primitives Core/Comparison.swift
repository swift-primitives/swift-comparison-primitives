// Comparison.swift
// Core three-way comparison result type.

/// Result of a three-way comparison: less, equal, or greater.
///
/// Represents the outcome of comparing two totally ordered values.
/// Corresponds to the signum of (a - b) in mathematical terms.
///
/// ## Example
///
/// ```swift
/// let result = Comparison(5, 10)
/// switch result {
/// case .less: print("5 < 10")
/// case .equal: print("5 == 10")
/// case .greater: print("5 > 10")
/// }
/// // Prints: "5 < 10"
/// ```
///
/// ## Move-Only Types
///
/// Unlike `Swift.Comparable`, `Comparison.Protocol` supports `~Copyable` types:
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
/// ```
public enum Comparison: Sendable, Hashable, CaseIterable {
    /// First value is less than second.
    case less

    /// Values are equal.
    case equal

    /// First value is greater than second.
    case greater
}

// MARK: - Codable

#if !hasFeature(Embedded)
    extension Comparison: Codable {}
#endif
