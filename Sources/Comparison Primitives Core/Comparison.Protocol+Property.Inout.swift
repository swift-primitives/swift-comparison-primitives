// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

public import Property_Primitives

/// Provides the `.compare` property to all `Comparison.Protocol` conformers.
///
/// This extension automatically makes fluent comparison APIs available
/// to any type conforming to `Comparison.Protocol`, including `~Copyable` types.
extension Comparison.`Protocol` where Self: ~Copyable {
    /// Access fluent comparison APIs.
    ///
    /// Returns a `Property.Inout` that provides comparison methods like
    /// `.to(other)`, `.isLess(than:)`, `.isGreater(than:)`, etc.
    ///
    /// ```swift
    /// var token = Token(id: 5)
    /// var other = Token(id: 10)
    ///
    /// token.compare.to(other)           // .less
    /// token.compare.isLess(than: other) // true
    /// ```
    public var compare: Property<Comparison.Compare, Self>.Inout {
        mutating _read {
            yield Property<Comparison.Compare, Self>.Inout(&self)
        }
    }
}

/// Provides the `.clamp` property to `Copyable` conformers of `Comparison.Protocol`.
///
/// Clamping requires `Copyable` because the operation may return a bound value.
extension Comparison.`Protocol` where Self: Copyable {
    /// Access clamping operations.
    ///
    /// Returns a `Property.Inout` that provides clamping methods like
    /// `.to(range)`, `.above(minimum)`, `.below(maximum)`.
    ///
    /// ```swift
    /// var value = 15
    /// value.clamp.to(0...10)  // 10
    /// value.clamp.above(20)   // 20
    /// value.clamp.below(5)    // 5
    /// ```
    public var clamp: Property<Comparison.Clamp, Self>.Inout {
        mutating _read {
            yield Property<Comparison.Clamp, Self>.Inout(&self)
        }
    }
}
