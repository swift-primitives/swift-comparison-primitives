# Comparison Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-comparison-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-comparison-primitives/actions/workflows/ci.yml)

`Comparison` — a three-way comparison value type with `.less` / `.equal` / `.greater` cases — and `Comparison.Protocol`, an ordering protocol that admits `~Copyable` types via `borrowing` parameters. Mirrors `Swift.Comparable` and, on Swift 6.4 and later, *is* `Swift.Comparable` via a namespace typealias once [SE-0499](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0499-support-non-copyable-simple-protocols.md) lands at your floor.

Refines [`swift-equation-primitives`](https://github.com/swift-primitives/swift-equation-primitives) at the type level, matching Swift stdlib's `Comparable: Equatable` chain.

---

## Key Features

- **Three-way comparison value type** — A dedicated `Comparison` enum beats the C-style `negative / zero / positive` `Int` convention: the type system enforces the domain, the cases carry semantic meaning, and the operations (reversal, monoidal `then`, query properties) have algebraic structure that integers don't.
- **Move-only ordering** — `Comparison.Protocol` lets `~Copyable` types implement `<` and `==` with `borrowing` parameters. Default `<=`, `>`, `>=` come from the protocol's extension.
- **Fluent `.compare` and `.clamp` accessors** — `value.compare.to(other)`, `value.compare.isLess(than: other)`, `value.clamp.between(low, and: high)` work on both stdlib `Comparable` types and on custom `Comparison.Protocol` conformers.
- **Lexicographic composition** — `.then(_:)` and `.then(with:)` build sort comparators across multiple fields in a single expression.
- **SE-0499 dual-mode** — Under Swift <6.4, the package ships its own protocol fork. Under Swift 6.4+, `Comparison.Protocol` is a typealias to `Swift.Comparable`. Conformances written today work on both compiler families.

---

## Quick Start

Compare two values via the three-way result type:

```swift
import Comparison_Primitives

let result = Comparison(comparing: 5, to: 10)   // .less
result.reversed                                 // .greater
!result                                         // .greater (prefix !)
```

Compose comparisons lexicographically across multiple fields. `then` is the monoid operation under `.equal` as identity:

```swift
struct Person { let name: String; let age: Int; let id: Int }

func compare(_ lhs: Person, _ rhs: Person) -> Comparison {
    Comparison(comparing: lhs.name, to: rhs.name)
        .then(Comparison(comparing: lhs.age, to: rhs.age))
        .then(Comparison(comparing: lhs.id, to: rhs.id))
}
```

A move-only token type conforms to the ordering protocol with `borrowing` parameters:

```swift
struct Token: ~Copyable, Comparison.`Protocol` {
    let priority: Int

    static func < (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.priority < rhs.priority
    }

    static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.priority == rhs.priority
    }
}

var a = Token(priority: 5)
let b = Token(priority: 10)
let isLess: Bool = a < b               // true
let result2 = a.compare.to(b)          // .less
```

The fluent `.compare` accessor works on stdlib `Comparable` types too:

```swift
var apple = "apple"
let banana = "banana"
apple.compare.to(banana)             // .less
apple.compare.isLess(than: banana)   // true
```

`.clamp` mirrors the shape for bound-restriction:

```swift
var temperature = 105.0
temperature.clamp.between(0.0, and: 100.0)   // 100.0
temperature.clamp.above(110.0)               // 110.0
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main")
]
```

Add the umbrella product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Comparison Primitives", package: "swift-comparison-primitives")
    ]
)
```

For narrower surface, depend on `Comparison Primitives Core` alone (value type + protocol, no stdlib bridge for fluent accessors).

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

Four library products plus a Test Support target:

| Product | Contents | When to import |
|---------|----------|----------------|
| `Comparison Primitives` | Umbrella — re-exports Core + Standard Library Integration | Most consumers |
| `Comparison Primitives Core` | `Comparison` value type, `Comparison.Protocol`, `Comparison.Compare`, `Comparison.Clamp` (without stdlib `Comparable` bridge) | When stdlib `.compare` / `.clamp` are unwanted |
| `Comparison Primitives Standard Library Integration` | Re-conformance of stdlib types under Swift <6.4; the `Swift.Comparable` bridge that powers `.compare` / `.clamp` on stdlib types | Pulled in transitively by the umbrella |
| `Comparison Primitives Test Support` | Re-export of upstream Test Support modules | Test target only |

The fluent `.compare` and `.clamp` accessors are backed by the [`Property.Inout`](https://github.com/swift-primitives/swift-property-primitives) pattern — fluent namespaces without per-type proxy structs, extensible from downstream code.

---

## Stability

Pre-1.0. The 0.1.0 surface — `Comparison` enum, `Comparison.Protocol`, `Comparison.Compare`, `Comparison.Clamp`, the protocol's reversal/chaining/boolean operations — is committed to source-compatibility through the dual-mode bridge. The `Comparison` enum and its operations are independent of the SE-0499-driven protocol question; they remain regardless of which compiler your consumer ships against. The eventual long-term shape, post-Swift-6.4-ecosystem-floor, is the protocol's typealias-to-stdlib reduction; the value type stays.

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS 26         | Yes | Full support |
| Linux            | Yes | Full support |
| Windows          | Yes | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Swift Embedded   | —   | Supported    |

---

## Related Packages

- [`swift-equation-primitives`](https://github.com/swift-primitives/swift-equation-primitives) — equality protocol that `Comparison.Protocol` refines.
- [`swift-hash-primitives`](https://github.com/swift-primitives/swift-hash-primitives) — typed hash output + `Hash.Protocol` (also refines `Equation.Protocol`).
- [`swift-property-primitives`](https://github.com/swift-primitives/swift-property-primitives) — `Property.Inout` powers the fluent `.compare` and `.clamp` accessors.
- [`swift-tagged-primitives`](https://github.com/swift-primitives/swift-tagged-primitives) — `Tagged` conditionally conforms to `Comparison.Protocol`.

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
