// Comparison.Protocol+Swift.Optional.swift
// Conditional conformance for Optional when Wrapped is Copyable.

extension Optional: Comparison.`Protocol` where Wrapped: Comparison.`Protocol`, Wrapped: Copyable {
    /// Returns whether the left-hand side is less than the right-hand side.
    ///
    /// Ordering follows Swift stdlib semantics:
    /// - `.none` is less than any `.some` value
    /// - `.some(a) < .some(b)` iff `a < b`
    ///
    /// - Note: Uses `copy` to enable pattern matching on borrowed enum values.
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
        switch lhsCopy {
        case .none:
            switch rhsCopy {
            case .none: return false  // nil == nil, not less
            case .some: return true   // nil < .some(any)
            }
        case let .some(l):
            switch rhsCopy {
            case .none: return false  // .some(any) > nil
            case let .some(r): return l < r
            }
        }
    }
}
