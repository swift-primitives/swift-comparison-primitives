// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

extension Comparison {
    /// Tag type for `.clamp` property extensions.
    ///
    /// Use this tag with `Property.Inout` to access clamping operations
    /// on types conforming to `Comparison.Protocol`.
    ///
    /// ## Automatic Availability
    ///
    /// Any type conforming to `Comparison.Protocol` automatically gets a
    /// `.clamp` property via protocol extension. No manual adoption needed.
    ///
    /// ## Available Operations
    ///
    /// | Operation | Returns | Description |
    /// |-----------|---------|-------------|
    /// | `.clamp.between(lower, and: upper)` | `Self` | Clamp between bounds |
    /// | `.clamp.above(minimum)` | `Self` | Clamp to minimum value |
    /// | `.clamp.below(maximum)` | `Self` | Clamp to maximum value |
    ///
    /// ## Example
    ///
    /// ```swift
    /// var value = 15
    /// value.clamp.between(0, and: 10)  // 10
    /// value.clamp.above(20)            // 20
    /// value.clamp.below(5)             // 5
    /// ```
    ///
    /// ## ~Copyable Support
    ///
    /// Clamping requires `Copyable` conformance because it may return
    /// one of the bound values, which requires copying.
    public enum Clamp {}
}
