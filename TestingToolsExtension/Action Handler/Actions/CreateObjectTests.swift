import Testing
import XcodeKit

struct TestingToolsTests {
    struct CreatingClassTests {
        @Test func selectingWordExcludingBrackets_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass()\n"]
            let highlightedText = getRangeOfText("TestClass", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass()\n",
                "\n",
                "class TestClass { }\n"
            ])
        }
        
        @Test func selectingWordIncludingBrackets_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass()\n"]
            let highlightedText = getRangeOfText("TestClass()", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            #expect(sut == [
                "let sut = TestClass()\n",
                "\n",
                "class TestClass { }\n"
            ])
        }
        
        @Test func selectingClassWithStringInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someString: \"Hello\")\n"]
            let highlightedText = getRangeOfText("TestClass(someString: \"Hello\")", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            #expect(sut == [
                "let sut = TestClass(someString: \"Hello\")\n",
                "\n",
                "class TestClass {\n",
                "    let someString: String\n",
                "\n",
                "    init(someString: String) {\n",
                "        self.someString = someString\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func selectingClassWithIntInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someInt: 42)\n"]
            let highlightedText = getRangeOfText("TestClass(someInt: 42)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass(someInt: 42)\n",
                "\n",
                "class TestClass {\n",
                "    let someInt: Int\n",
                "\n",
                "    init(someInt: Int) {\n",
                "        self.someInt = someInt\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func selectingClassWithDoubleInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someDouble: 3.14)\n"]
            let highlightedText = getRangeOfText("TestClass(someDouble: 3.14)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass(someDouble: 3.14)\n",
                "\n",
                "class TestClass {\n",
                "    let someDouble: Double\n",
                "\n",
                "    init(someDouble: Double) {\n",
                "        self.someDouble = someDouble\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func selectingClassWithBoolInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someBool: false)\n"]
            let highlightedText = getRangeOfText("TestClass(someBool: false)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass(someBool: false)\n",
                "\n",
                "class TestClass {\n",
                "    let someBool: Bool\n",
                "\n",
                "    init(someBool: Bool) {\n",
                "        self.someBool = someBool\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test("Unknown type should expand to editor placeholder - unicode characters required to prevent placeholder expanding in tests")
        func selectingClassWithUnknownParameterInInit_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someUnknown: unknownProperty)\n"]
            let highlightedText = getRangeOfText("TestClass(someUnknown: unknownProperty)", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass(someUnknown: unknownProperty)\n",
                "\n",
                "class TestClass {\n",
                "    let someUnknown: \u{003C}#Type#\u{003E}\n",
                "\n",
                "    init(someUnknown: \u{003C}#Type#\u{003E}) {\n",
                "        self.someUnknown = someUnknown\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func selectingClassWithMultipleParameters_correctlyCreatesClass() throws {
            let text = ["let sut = TestClass(someBool: true, someInt: 42)\n"]
            let highlightedText = getRangeOfText("TestClass(someBool: true, someInt: 42)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createClass,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestClass(someBool: true, someInt: 42)\n",
                "\n",
                "class TestClass {\n",
                "    let someBool: Bool\n",
                "    let someInt: Int\n",
                "\n",
                "    init(someBool: Bool, someInt: Int) {\n",
                "        self.someBool = someBool\n",
                "        self.someInt = someInt\n",
                "    }\n",
                "}\n"
            ])
        }
    }
        
    struct CreatingStructTests {
        @Test func selectingWordExcludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()\n"]
            let highlightedText = getRangeOfText("TestStruct", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestStruct()\n",
                "\n",
                "struct TestStruct { }\n"
            ])
        }
        
        @Test func selectingWordIncludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()\n"]
            let highlightedText = getRangeOfText("TestStruct()", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )

            #expect(sut == [
                "let sut = TestStruct()\n",
                "\n",
                "struct TestStruct { }\n"
            ])
        }
        
        @Test func selectingStructWithStringInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someString: \"Hello\")\n"]
            let highlightedText = getRangeOfText("TestStruct(someString: \"Hello\")", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestStruct(someString: \"Hello\")\n",
                "\n",
                "struct TestStruct {\n",
                "    let someString: String\n",
                "}\n"
            ])
        }
        
        @Test func selectingStructWithIntInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someInt: 42)\n"]
            let highlightedText = getRangeOfText("TestStruct(someInt: 42)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )

            #expect(sut == [
                "let sut = TestStruct(someInt: 42)\n",
                "\n",
                "struct TestStruct {\n",
                "    let someInt: Int\n",
                "}\n"
            ])
        }
        
        @Test func selectingStructWithDoubleInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someDouble: 3.14)\n"]
            let highlightedText = getRangeOfText("TestStruct(someDouble: 3.14)", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )

            #expect(sut == [
                "let sut = TestStruct(someDouble: 3.14)\n",
                "\n",
                "struct TestStruct {\n",
                "    let someDouble: Double\n",
                "}\n"
            ])
        }
        
        @Test func selectingStructWithBoolInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true)\n"]
            let highlightedText = getRangeOfText("TestStruct(someBool: true)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )

            #expect(sut == [
                "let sut = TestStruct(someBool: true)\n",
                "\n",
                "struct TestStruct {\n",
                "    let someBool: Bool\n",
                "}\n"
            ])
        }
        
        @Test("Unknown type should expand to editor placeholder - unicode characters required to prevent placeholder expanding in tests")
        func selectingStructWithUnknownParamerInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someUnknown: unknownProperty)\n"]
            let highlightedText = getRangeOfText("TestStruct(someUnknown: unknownProperty)", from: text)!
            
            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )

            #expect(sut == [
                "let sut = TestStruct(someUnknown: unknownProperty)\n",
                "\n",
                "struct TestStruct {\n",
                "    let someUnknown: \u{003C}#Type#\u{003E}\n",
                "}\n"
            ])
        }
        
        @Test func selectingStructWithMultipleParameters_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true, someInt: 42)\n"]
            let highlightedText = getRangeOfText("TestStruct(someBool: true, someInt: 42)", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestStruct(someBool: true, someInt: 42)\n",
                "\n",
                "struct TestStruct {\n",
                "    let someBool: Bool\n",
                "    let someInt: Int\n",
                "}\n"
            ])
        }
    }
    
    struct ErrorTests {
        @Test(arguments: [Action.createStruct, .createClass])
        func multipleSelectedText_throwsError(action: Action) {
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
                try CommandActionHandler.handle(
                    action: action,
                    allText: text,
                    selections: [firstSelection, secondSelection],
                    tabWidth: 4
                )
            }
        }
        
        @Test(arguments: [Action.createStruct, .createClass])
        func multipleLineSelectedText_throwsError(action: Action) {
            let text = ["let sut = TestStruct()"]
            let multipleLineSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
                try CommandActionHandler.handle(
                    action: action,
                    allText: text,
                    selections: [multipleLineSelection],
                    tabWidth: 4
                )
            }
        }
        
        @Test(arguments: [Action.createStruct, .createClass])
        func passingASelectionWhenNoText_throwsError(action: Action) throws {
            let emptyPage = [String]()
            let aSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 0, column: 10)
            )
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try CommandActionHandler.handle(
                    action: action,
                    allText: emptyPage,
                    selections: [aSelection],
                    tabWidth: 4
                )
            }
        }
        
        @Test(arguments: [Action.createStruct, .createClass])
        func passingASelectionThatDoesntExistOnPage_throwsError(action: Action) throws {
            let text = ["let sut = TestStruct()"]
            let nonExistentSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 1, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try CommandActionHandler.handle(
                    action: action,
                    allText: text,
                    selections: [nonExistentSelection],
                    tabWidth: 4
                )
            }
        }
        
        @Test func selectingWordInMultilinePage_returnsStruct() throws {
            let text = [
                "let sut = TestStruct()\n",
                "   let anotherSut = AnotherStruct()\n"
            ]
            let highlightedText = getRangeOfText("AnotherStruct", from: text)!

            let sut = try CommandActionHandler.handle(
                action: .createStruct,
                allText: text,
                selections: [highlightedText],
                tabWidth: 4
            )
            
            #expect(sut == [
                "let sut = TestStruct()\n",
                "   let anotherSut = AnotherStruct()\n",
                "\n",
                "struct AnotherStruct { }\n"
            ])
        }
        
        @Test(arguments: [Action.createStruct, .createClass])
        func halfSelectingStructWithProperties_throwsError(action: Action) throws {
            let text = ["let sut = TestStruct(someInt: 42)"]
            let highlightedText = getRangeOfText("TestStruct(someInt:", from: text)!

            #expect(throws: TestingToolsError.invalidSelection) {
                try CommandActionHandler.handle(
                    action: action,
                    allText: text,
                    selections: [highlightedText],
                    tabWidth: 4
                )
            }
        }
    }
}
