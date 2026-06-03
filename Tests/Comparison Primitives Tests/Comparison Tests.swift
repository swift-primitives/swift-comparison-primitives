// Comparison Tests.swift
// Tests for Comparison

import Testing

@testable import Comparison_Primitives

// MARK: - Suite Structure

@Suite
struct `Comparison Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit sub-suites

extension `Comparison Tests`.Unit {
    @Suite struct Cases {}
    @Suite struct Reversal {}
    @Suite struct Chaining {}
    @Suite struct `Boolean Properties` {}
    @Suite struct `Swift.Comparable Construction` {}
    @Suite struct `Protocol Conformances` {}
    @Suite struct `Comparison.Protocol Construction` {}
    @Suite struct `Fluent Compare API` {}
    @Suite struct `Fluent Clamp API` {}
    @Suite struct `Swift.Comparable Fluent API` {}
    @Suite struct `Lexicographic Comparison` {}
}

// MARK: - Fixtures

/// `~Copyable` Comparison.Protocol-conformer used across the protocol/fluent tests.
private struct Token: ~Copyable, Comparison.`Protocol` {
    let id: Int
}

extension Token {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id < rhs.id
    }

    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id == rhs.id
    }
}

/// Second `~Copyable` conformer: witnesses that `.compare` arrives from the
/// protocol extension without a manual declaration.
private struct Token2: ~Copyable, Comparison.`Protocol` {
    let value: Int
}

extension Token2 {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value < rhs.value
    }

    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.value == rhs.value
    }
}

/// Copyable Comparison.Protocol-conformer for the Clamp tests (Clamp requires Copyable).
private struct Score: Comparison.`Protocol` {
    var value: Int
}

extension Score {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

/// Actor fixture exercising Sendable passing of Comparison.
private actor Holder {
    var value: Comparison = .equal
}

extension Holder {
    func set(_ v: Comparison) { value = v }
    func get() -> Comparison { value }
}

/// Multi-field record for the lexicographic-comparison example.
private struct Person: Equatable {
    let name: String
    let age: Int
    let id: Int
}

private func compare(_ lhs: Person, _ rhs: Person) -> Comparison {
    Comparison(comparing: lhs.name, to: rhs.name)
        .then(Comparison(comparing: lhs.age, to: rhs.age))
        .then(Comparison(comparing: lhs.id, to: rhs.id))
}

// MARK: - Cases

extension `Comparison Tests`.Unit.Cases {
    @Test
    func `All cases exist`() {
        let cases = Comparison.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.less))
        #expect(cases.contains(.equal))
        #expect(cases.contains(.greater))
    }
}

// MARK: - Reversal (Involution Property)

extension `Comparison Tests`.Unit.Reversal {
    @Test
    func `Reversal mapping`() {
        #expect(Comparison.less.reversed == .greater)
        #expect(Comparison.equal.reversed == .equal)
        #expect(Comparison.greater.reversed == .less)
    }

    @Test
    func `Reversal is involution: rev(rev(x)) = x`() {
        for value in Comparison.allCases {
            #expect(value.reversed.reversed == value)
        }
    }

    @Test
    func `Prefix ! operator`() {
        #expect(!Comparison.less == .greater)
        #expect(!Comparison.equal == .equal)
        #expect(!Comparison.greater == .less)
    }

    @Test
    func `Prefix ! is equivalent to reversed`() {
        for value in Comparison.allCases {
            #expect(!value == value.reversed)
        }
    }
}

// MARK: - Chaining (Monoid Properties)

extension `Comparison Tests`.Unit.Chaining {
    @Test
    func `Left identity: equal.then(x) = x`() {
        for value in Comparison.allCases {
            #expect(Comparison.equal.then(value) == value)
        }
    }

    @Test
    func `Right identity: x.then(equal) = x`() {
        for value in Comparison.allCases {
            #expect(value.then(.equal) == value)
        }
    }

    @Test
    func `Associativity: (x.then(y)).then(z) = x.then(y.then(z))`() {
        let cases = Comparison.allCases
        for x in cases {
            for y in cases {
                for z in cases {
                    let left = x.then(y).then(z)
                    let right = x.then(y.then(z))
                    #expect(left == right)
                }
            }
        }
    }

    @Test
    func `Short-circuit behavior`() {
        #expect(Comparison.less.then(.greater) == .less)
        #expect(Comparison.greater.then(.less) == .greater)
        #expect(Comparison.equal.then(.less) == .less)
        #expect(Comparison.equal.then(.greater) == .greater)
    }

    @Test
    func `Lazy chaining with then(with:)`() {
        var evaluationCount = 0

        let lazyValue: () -> Comparison = {
            evaluationCount += 1
            return .greater
        }

        // Should NOT evaluate when primary is decisive
        _ = Comparison.less.then(with: lazyValue)
        #expect(evaluationCount == 0)

        _ = Comparison.greater.then(with: lazyValue)
        #expect(evaluationCount == 0)

        // Should evaluate when primary is equal
        let result = Comparison.equal.then(with: lazyValue)
        #expect(evaluationCount == 1)
        #expect(result == .greater)
    }
}

// MARK: - Boolean Properties

extension `Comparison Tests`.Unit.`Boolean Properties` {
    @Test
    func `isLess`() {
        #expect(Comparison.less.isLess == true)
        #expect(Comparison.equal.isLess == false)
        #expect(Comparison.greater.isLess == false)
    }

    @Test
    func `isEqual`() {
        #expect(Comparison.less.isEqual == false)
        #expect(Comparison.equal.isEqual == true)
        #expect(Comparison.greater.isEqual == false)
    }

    @Test
    func `isGreater`() {
        #expect(Comparison.less.isGreater == false)
        #expect(Comparison.equal.isGreater == false)
        #expect(Comparison.greater.isGreater == true)
    }

    @Test
    func `isLessOrEqual`() {
        #expect(Comparison.less.isLessOrEqual == true)
        #expect(Comparison.equal.isLessOrEqual == true)
        #expect(Comparison.greater.isLessOrEqual == false)
    }

    @Test
    func `isGreaterOrEqual`() {
        #expect(Comparison.less.isGreaterOrEqual == false)
        #expect(Comparison.equal.isGreaterOrEqual == true)
        #expect(Comparison.greater.isGreaterOrEqual == true)
    }
}

// MARK: - Construction from Swift.Comparable

extension `Comparison Tests`.Unit.`Swift.Comparable Construction` {
    @Test
    func `Int comparison`() {
        #expect(Comparison(comparing: 1, to: 2) == .less)
        #expect(Comparison(comparing: 2, to: 2) == .equal)
        #expect(Comparison(comparing: 3, to: 2) == .greater)
    }

    @Test
    func `String comparison`() {
        #expect(Comparison(comparing: "apple", to: "banana") == .less)
        #expect(Comparison(comparing: "hello", to: "hello") == .equal)
        #expect(Comparison(comparing: "zebra", to: "apple") == .greater)
    }

    @Test
    func `Double comparison`() {
        #expect(Comparison(comparing: 1.5, to: 2.5) == .less)
        #expect(Comparison(comparing: 2.5, to: 2.5) == .equal)
        #expect(Comparison(comparing: 3.5, to: 2.5) == .greater)
    }
}

// MARK: - Protocol Conformances

extension `Comparison Tests`.Unit.`Protocol Conformances` {
    @Test
    func `Hashable - can be used in Set`() {
        let set: Set<Comparison> = [.less, .equal, .greater]
        #expect(set.count == 3)
    }

    @Test
    func `Hashable - can be used as dictionary key`() {
        let dict: [Comparison: String] = [
            .less: "less",
            .equal: "equal",
            .greater: "greater",
        ]
        #expect(dict[.less] == "less")
        #expect(dict[.equal] == "equal")
        #expect(dict[.greater] == "greater")
    }

    @Test
    func `Sendable - can pass to actor`() async {
        let holder = Holder()
        await holder.set(.less)
        let result = await holder.get()
        #expect(result == .less)
    }
}

// MARK: - Construction from Comparison.Protocol (~Copyable)

extension `Comparison Tests`.Unit.`Comparison.Protocol Construction` {
    @Test
    func `~Copyable type comparison via Result`() {
        let a = Token(id: 1)
        let b = Token(id: 2)
        let c = Token(id: 1)

        #expect(Comparison(a, b) == .less)
        #expect(Comparison(b, a) == .greater)
        #expect(Comparison(a, c) == .equal)
    }

    @Test
    func `~Copyable operators: less than`() {
        let a = Token(id: 5)
        let b = Token(id: 10)
        let result: Bool = a < b
        #expect(result == true)
    }

    @Test
    func `~Copyable operators: greater than`() {
        let a = Token(id: 10)
        let b = Token(id: 5)
        let result: Bool = a > b
        #expect(result == true)
    }

    @Test
    func `~Copyable operators: less than or equal`() {
        let a = Token(id: 5)
        let b = Token(id: 5)
        let result: Bool = a <= b
        #expect(result == true)
    }

    @Test
    func `~Copyable operators: greater than or equal`() {
        let a = Token(id: 5)
        let b = Token(id: 5)
        let result: Bool = a >= b
        #expect(result == true)
    }

    @Test
    func `~Copyable operators: equal`() {
        let a = Token(id: 5)
        let b = Token(id: 5)
        let result: Bool = a == b
        #expect(result == true)
    }
}

// MARK: - Fluent Compare API

extension `Comparison Tests`.Unit.`Fluent Compare API` {
    @Test
    func `.compare.to() returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)
        var c = Token(id: 5)

        #expect(a.compare.to(b) == .less)
        #expect(b.compare.to(a) == .greater)
        #expect(a.compare.to(c) == .equal)
    }

    @Test
    func `.compare.isLess(than:) returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)

        #expect(a.compare.isLess(than: b) == true)
        #expect(b.compare.isLess(than: a) == false)
    }

    @Test
    func `.compare.isGreater(than:) returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)

        #expect(b.compare.isGreater(than: a) == true)
        #expect(a.compare.isGreater(than: b) == false)
    }

    @Test
    func `.compare.isEqual(to:) returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)
        var c = Token(id: 5)

        #expect(a.compare.isEqual(to: c) == true)
        #expect(a.compare.isEqual(to: b) == false)
    }

    @Test
    func `.compare.isLessOrEqual(to:) returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)
        var c = Token(id: 5)

        #expect(a.compare.isLessOrEqual(to: b) == true)
        #expect(a.compare.isLessOrEqual(to: c) == true)
        #expect(b.compare.isLessOrEqual(to: a) == false)
    }

    @Test
    func `.compare.isGreaterOrEqual(to:) returns correct result`() {
        var a = Token(id: 5)
        var b = Token(id: 10)
        var c = Token(id: 5)

        #expect(b.compare.isGreaterOrEqual(to: a) == true)
        #expect(a.compare.isGreaterOrEqual(to: c) == true)
        #expect(a.compare.isGreaterOrEqual(to: b) == false)
    }

    @Test
    func `Automatic .compare property via protocol extension`() {
        // Token2 doesn't manually define .compare - it gets it from the protocol extension
        var x = Token2(value: 1)
        var y = Token2(value: 2)

        #expect(x.compare.to(y) == .less)
        #expect(x.compare.isLess(than: y) == true)
    }
}

// MARK: - Fluent Clamp API

extension `Comparison Tests`.Unit.`Fluent Clamp API` {
    @Test
    func `.clamp.between() clamps to lower bound`() {
        var score = Score(value: -5)
        let result = score.clamp.between(Score(value: 0), and: Score(value: 100))
        #expect(result.value == 0)
    }

    @Test
    func `.clamp.between() clamps to upper bound`() {
        var score = Score(value: 150)
        let result = score.clamp.between(Score(value: 0), and: Score(value: 100))
        #expect(result.value == 100)
    }

    @Test
    func `.clamp.between() returns value when in range`() {
        var score = Score(value: 50)
        let result = score.clamp.between(Score(value: 0), and: Score(value: 100))
        #expect(result.value == 50)
    }

    @Test
    func `.clamp.above() clamps to minimum`() {
        var score = Score(value: -10)
        let result = score.clamp.above(Score(value: 0))
        #expect(result.value == 0)
    }

    @Test
    func `.clamp.above() returns value when above minimum`() {
        var score = Score(value: 50)
        let result = score.clamp.above(Score(value: 0))
        #expect(result.value == 50)
    }

    @Test
    func `.clamp.below() clamps to maximum`() {
        var score = Score(value: 150)
        let result = score.clamp.below(Score(value: 100))
        #expect(result.value == 100)
    }

    @Test
    func `.clamp.below() returns value when below maximum`() {
        var score = Score(value: 50)
        let result = score.clamp.below(Score(value: 100))
        #expect(result.value == 50)
    }
}

// MARK: - Swift.Comparable Fluent API

extension `Comparison Tests`.Unit.`Swift.Comparable Fluent API` {
    @Test
    func `String has .compare property`() {
        var apple = "apple"
        let banana = "banana"

        #expect(apple.compare.to(banana) == .less)
        #expect(apple.compare.isLess(than: banana) == true)
        #expect(apple.compare.isGreater(than: banana) == false)
        #expect(apple.compare.isEqual(to: "apple") == true)
    }

    @Test
    func `Double has .compare property`() {
        var a = 1.5
        let b = 2.5

        #expect(a.compare.to(b) == .less)
        #expect(a.compare.isLess(than: b) == true)
        #expect(a.compare.isGreater(than: b) == false)
        #expect(a.compare.isEqual(to: 1.5) == true)
    }

    @Test
    func `Float has .compare property`() {
        var a: Float = 3.14
        let b: Float = 2.71

        #expect(a.compare.to(b) == .greater)
        #expect(a.compare.isGreater(than: b) == true)
        #expect(a.compare.isLess(than: b) == false)
    }

    @Test
    func `Character has .compare property`() {
        var a: Character = "a"
        let z: Character = "z"

        #expect(a.compare.to(z) == .less)
        #expect(a.compare.isLess(than: z) == true)
        #expect(a.compare.isGreaterOrEqual(to: "a") == true)
    }

    @Test
    func `Int uses Comparison.Protocol path (both paths work)`() {
        // Int conforms to both Comparison.Protocol and Swift.Comparable
        // Either path should work
        var a = 5
        let b = 10

        #expect(a.compare.to(b) == .less)
        #expect(a.compare.isLess(than: b) == true)
        #expect(a.compare.isLessOrEqual(to: 5) == true)
    }

    @Test
    func `String has .clamp property`() {
        var name = "bob"
        #expect(name.clamp.between("alice", and: "charlie") == "bob")
        #expect(name.clamp.above("charlie") == "charlie")
        #expect(name.clamp.below("alice") == "alice")
    }

    @Test
    func `Double has .clamp property`() {
        var temp = 105.0
        #expect(temp.clamp.between(0.0, and: 100.0) == 100.0)
        #expect(temp.clamp.above(110.0) == 110.0)
        #expect(temp.clamp.below(50.0) == 50.0)
    }
}

// MARK: - Lexicographic Comparison Example

extension `Comparison Tests`.Unit.`Lexicographic Comparison` {
    @Test
    func `Multi-field comparison`() {
        let alice1 = Person(name: "Alice", age: 30, id: 1)
        let alice2 = Person(name: "Alice", age: 30, id: 2)
        let alice3 = Person(name: "Alice", age: 25, id: 1)
        let bob = Person(name: "Bob", age: 30, id: 1)

        // Same name, same age, different id
        #expect(compare(alice1, alice2) == .less)

        // Same name, different age
        #expect(compare(alice1, alice3) == .greater)

        // Different name
        #expect(compare(alice1, bob) == .less)

        // Same person
        #expect(compare(alice1, alice1) == .equal)
    }
}
