// ComparisonTests.swift
// Tests for Comparison

import Testing

@testable import Comparison_Primitives

@Suite("Comparison")
struct ComparisonResultTests {

    // MARK: - Basic Cases

    @Suite("Cases")
    struct CasesTests {
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

    @Suite("Reversal")
    struct ReversalTests {
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

    @Suite("Chaining")
    struct ChainingTests {
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

    @Suite("Boolean Properties")
    struct BooleanPropertiesTests {
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

    @Suite("Swift.Comparable Construction")
    struct SwiftComparableConstructionTests {
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

    @Suite("Protocol Conformances")
    struct ProtocolConformancesTests {
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
            actor TestActor {
                var value: Comparison = .equal
                func set(_ v: Comparison) { value = v }
                func get() -> Comparison { value }
            }

            let actor = TestActor()
            await actor.set(.less)
            let result = await actor.get()
            #expect(result == .less)
        }
    }

    // MARK: - Construction from Comparison.Protocol (~Copyable)

    @Suite("Comparison.Protocol Construction")
    struct ComparisonProtocolConstructionTests {
        struct Token: ~Copyable, Comparison.`Protocol` {
            let id: Int

            static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
                lhs.id < rhs.id
            }

            static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
                lhs.id == rhs.id
            }
        }

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

    // MARK: - Lexicographic Comparison Example

    @Suite("Lexicographic Comparison")
    struct LexicographicComparisonTests {
        struct Person: Equatable {
            let name: String
            let age: Int
            let id: Int
        }

        func compare(_ lhs: Person, _ rhs: Person) -> Comparison {
            Comparison(comparing: lhs.name, to: rhs.name)
                .then(Comparison(comparing: lhs.age, to: rhs.age))
                .then(Comparison(comparing: lhs.id, to: rhs.id))
        }

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
}
