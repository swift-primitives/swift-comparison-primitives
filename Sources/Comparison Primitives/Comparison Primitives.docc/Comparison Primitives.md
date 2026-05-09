# ``Comparison_Primitives``

@Metadata {
    @DisplayName("Comparison Primitives")
    @TitleHeading("Swift Primitives")
}

A three-way comparison value type and an ordering protocol with `borrowing` parameters, so `~Copyable` types can compare without being copied.

## Overview

The package ships two surfaces. The `Comparison` enum is a three-way result type — `.less`, `.equal`, `.greater` — with reversal (involution), monoidal `then(_:)` chaining, boolean query properties, and construction from any pair of `Swift.Comparable` or `Comparison.Protocol` values. The `Comparison.Protocol` mirrors `Swift.Comparable` with `borrowing` parameters, so move-only types can implement `<` and `==` without being consumed.

```swift
import Comparison_Primitives

// Three-way comparison value type
let result = Comparison(comparing: 5, to: 10)   // .less

// Lexicographic composition via the monoid operation
struct Person { let name: String; let age: Int }
func compare(_ a: Person, _ b: Person) -> Comparison {
    Comparison(comparing: a.name, to: b.name)
        .then(Comparison(comparing: a.age, to: b.age))
}

// Move-only ordering
struct Token: ~Copyable, Comparison.`Protocol` {
    let priority: Int
    static func < (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.priority < rhs.priority
    }
    static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.priority == rhs.priority
    }
}
```

`Comparison.Protocol` refines ``Equation_Primitives``'s `Equation.Protocol`, matching Swift stdlib's `Comparable: Equatable` chain. ``Hash_Primitives`` refines the same root, encoding the equals/hashCode contract at the type level.

## Algebraic structure

The three-way `Comparison` enum carries algebraic structure that integer-based comparison conventions (C's `strcmp`, Java's `Comparator.compare`) lack:

- **Trichotomy** — total orders produce exactly three outcomes; no fourth case to handle.
- **Reversal is involution** — `value.reversed.reversed == value`.
- **`then(_:)` is the monoid operation** with `.equal` as identity. Lexicographic composition is associative, so `(a.then(b)).then(c)` and `a.then(b.then(c))` agree.

The lazy form `then(with:)` defers later comparisons until the prior one returns `.equal` — useful when subsequent comparisons are expensive.

## SE-0499 dual-mode

Under Swift <6.4, `Comparison.Protocol` is the package's own fork of `Swift.Comparable` with `borrowing` parameters. Under Swift 6.4+, the protocol is a typealias to `Swift.Comparable`:

```swift
#if swift(>=6.4)
    extension Comparison {
        public typealias `Protocol` = Swift.Comparable
    }
#else
    extension Comparison {
        public protocol `Protocol`: Equation.`Protocol`, ~Copyable {
            static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool
        }
    }
#endif
```

The `Comparison` enum (the three-way result type) and the `.compare` / `.clamp` fluent accessors are independent of the SE-0499 question — they ship in both compiler modes.

## Topics

### Three-way comparison

- ``Comparison``

### Ordering protocol

`Comparison.Protocol` is the ordering protocol; under Swift 6.4+ it is a typealias to `Swift.Comparable`. The fork branch declares `protocol \`Protocol\`: Equation.\`Protocol\`, ~Copyable` with a `borrowing static func <` requirement and provides default `<=`, `>`, `>=`.

### Fluent accessors

- `Comparison.Compare` — the `.compare` namespace tag for fluent boolean queries (`isLess(than:)`, `isGreater(than:)`, `isEqual(to:)`, `isLessOrEqual(to:)`, `isGreaterOrEqual(to:)`, `to(_:)` returning `Comparison`).
- `Comparison.Clamp` — the `.clamp` namespace tag for bound-restriction (`between(_:and:)`, `above(_:)`, `below(_:)`).

Both accessor namespaces work on stdlib `Comparable` types and on custom `Comparison.Protocol` conformers, backed by `Property.Inout` from `swift-property-primitives`.
