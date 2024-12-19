import Testing
import XcodeKit

struct TestingToolsTests {
    struct CreatingClassTests {
        @Test func selectingWordExcludingBrackets_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass()"]
            let highlightedText = getRangeOfText("TestClass", from: text)!
            
            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            #expect(sut == "class TestClass { }")
        }
        
        @Test func selectingWordIncludingBrackets_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass()"]
            let highlightedText = getRangeOfText("TestClass()", from: text)!
            
            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            #expect(sut == "class TestClass { }")
        }
        
        @Test func selectingClassWithStringInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someString: \"Hello\")"]
            let highlightedText = getRangeOfText("TestClass(someString: \"Hello\")", from: text)!
            
            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someString: String
            
                init(someString: String) {
                    self.someString = someString
                }
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingClassWithIntInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someInt: 42)"]
            let highlightedText = getRangeOfText("TestClass(someInt: 42)", from: text)!

            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someInt: Int
            
                init(someInt: Int) {
                    self.someInt = someInt
                }
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingClassWithDoubleInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someDouble: 3.14)"]
            let highlightedText = getRangeOfText("TestClass(someDouble: 3.14)", from: text)!

            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someDouble: Double
            
                init(someDouble: Double) {
                    self.someDouble = someDouble
                }
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingClassWithBoolInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someBool: false)"]
            let highlightedText = getRangeOfText("TestClass(someBool: false)", from: text)!

            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someBool: Bool
            
                init(someBool: Bool) {
                    self.someBool = someBool
                }
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test("Unknown type should expand to editor placeholder - unicode characters required to prevent placeholder expanding in tests")
        func selectingClassWithUnknownParameterInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someUnknown: unknownProperty)"]
            let highlightedText = getRangeOfText("TestClass(someUnknown: unknownProperty)", from: text)!
            
            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someUnknown: \u{003C}#Type#\u{003E}
            
                init(someUnknown: \u{003C}#Type#\u{003E}) {
                    self.someUnknown = someUnknown
                }
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingClassWithMultipleParameters_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someBool: true, someInt: 42)"]
            let highlightedText = getRangeOfText("TestClass(someBool: true, someInt: 42)", from: text)!

            let sut = try createClass(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            class TestClass {
                let someBool: Bool
                let someInt: Int
            
                init(someBool: Bool, someInt: Int) {
                    self.someBool = someBool
                    self.someInt = someInt
                }
            }
            """
            #expect(sut == expectedValue)
        }
    }
    struct CreatingStructTests {
        @Test func selectingWordExcludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()"]
            let highlightedText = getRangeOfText("TestStruct", from: text)!
            
            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            #expect(sut == "struct TestStruct { }")
        }
        
        @Test func selectingWordIncludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()"]
            let highlightedText = getRangeOfText("TestStruct()", from: text)!
            
            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            #expect(sut == "struct TestStruct { }")
        }
        
        @Test func selectingStructWithStringInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someString: \"Hello\")"]
            let highlightedText = getRangeOfText("TestStruct(someString: \"Hello\")", from: text)!
            
            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someString: String
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithIntInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someInt: 42)"]
            let highlightedText = getRangeOfText("TestStruct(someInt: 42)", from: text)!

            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someInt: Int
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithDoubleInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someDouble: 3.14)"]
            let highlightedText = getRangeOfText("TestStruct(someDouble: 3.14)", from: text)!
            
            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someDouble: Double
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithBoolInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true)"]
            let highlightedText = getRangeOfText("TestStruct(someBool: true)", from: text)!

            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someBool: Bool
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test("Unknown type should expand to editor placeholder - unicode characters required to prevent placeholder expanding in tests")
        func selectingStructWithUnknownParamerInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someUnknown: unknownProperty)"]
            let highlightedText = getRangeOfText("TestStruct(someUnknown: unknownProperty)", from: text)!
            
            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someUnknown: \u{003C}#Type#\u{003E}
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithMultipleParameters_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true, someInt: 42)"]
            let highlightedText = getRangeOfText("TestStruct(someBool: true, someInt: 42)", from: text)!

            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            let expectedValue = """
            struct TestStruct {
                let someBool: Bool
                let someInt: Int
            }
            """
            #expect(sut == expectedValue)
        }
    }
    
    
    struct ErrorTests {
        @Test func multipleSelectedText_throwsError() {
            let text = ["let sut = TestStruct()"]
            let firstSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 0, column: 3)
            )
            let secondSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 5),
                end: XCSourceTextPosition(line: 0, column: 10)
            )
            
            #expect(throws: TestingToolsError.multipleSelectionNotSupported) {
                try createStruct(allText: text, selectedText: [firstSelection, secondSelection])
            }
        }
        
        @Test func multipleLineSelectedText_throwsError() {
            let text = ["let sut = TestStruct()"]
            let multipleLineSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
                try createStruct(allText: text, selectedText: [multipleLineSelection])
            }
        }
        
        @Test func passingASelectionWhenNoText_returnsNil() throws {
            let emptyPage = [String]()
            let aSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 0, column: 10)
            )
            
            let sut = try createStruct(allText: emptyPage, selectedText: [aSelection])
            
            #expect(sut == nil, "This doesn't throw an error since it's not really a situation that should happen")
        }
        
        @Test func passingASelectionThatDoesntExistOnPage_returnsNil() throws {
            let text = ["let sut = TestStruct()"]
            let nonExistentSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 1, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            let sut = try createStruct(allText: text, selectedText: [nonExistentSelection])
            
            #expect(sut == nil, "This doesn't throw an error since it's not really a situation that should happen")
        }
        
        @Test func selectingWordInMultilinePage_returnsStruct() throws {
            let text = [
                "let sut = TestStruct()",
                "   let anotherSut = AnotherStruct()"
            ]
            let highlightedText = getRangeOfText("AnotherStruct", from: text)!

            let sut = try createStruct(allText: text, selectedText: [highlightedText])
            
            #expect(sut == "struct AnotherStruct { }")
        }
        
        @Test func halfSelectingStructWithProperties_throwsError() throws {
            let text = ["let sut = TestStruct(someInt: 42)"]
            let highlightedText = getRangeOfText("TestStruct(someInt:", from: text)!

            #expect(throws: TestingToolsError.invalidSelection) {
                try createStruct(allText: text, selectedText: [highlightedText])
            }
        }
    }
}
