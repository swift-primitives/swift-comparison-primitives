// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

extension Comparison {
    /// Tag type for `.compare` property extensions.
    ///
    /// Use this tag with `Property.View` to access fluent comparison APIs
    /// on types conforming to `Comparison.Protocol`.
    ///
    /// ## Automatic Availability
    ///
    /// Any type conforming to `Comparison.Protocol` automatically gets a
    /// `.compare` property via protocol extension. No manual adoption needed.
    ///
    /// ## Available Operations
    ///
    /// | Operation | Returns | Description |
    /// |-----------|---------|-------------|
    /// | `.compare.to(other)` | `Comparison.Result` | Three-way comparison |
    /// | `.compare.isLess(than: other)` | `Bool` | Less than check |
    /// | `.compare.isGreater(than: other)` | `Bool` | Greater than check |
    /// | `.compare.isEqual(to: other)` | `Bool` | Equality check |
    /// | `.compare.isLessOrEqual(to: other)` | `Bool` | Less or equal check |
    /// | `.compare.isGreaterOrEqual(to: other)` | `Bool` | Greater or equal check |
    ///
    /// ## Example
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
    ///
    /// var a = Token(id: 5)
    /// var b = Token(id: 10)
    ///
    /// a.compare.to(b)           // .less
    /// a.compare.isLess(than: b) // true
    /// ```
    public enum Compare {}
}
