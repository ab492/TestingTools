import Testing
import XcodeKit

struct CreatePropertyTests {
    struct InstancePropertyTests {
        @Test func testCreatingInstancePropertyOnStruct() throws {
            let text = [
                "import SomeLibrary\n",
                "\n",
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!

            
            let sut = try makeSut(
                action: .createInstanceProperty,
                allText: text,
                selections: [highlightedText]
            )
            
            #expect(sut == [
                "import SomeLibrary\n",
                "\n",
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "\n",
                "        let someProperty = \u{003C}#Type#\u{003E}\n",
                "\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func testCreatingInstancePropertyOnClass() throws {
            let text = [
                "class TestClass {\n",
                "    func someDummyMethod() {\n",
                "        someProperty.callSomeMethod()\n",
                "    }\n",
                "}\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!

            
            let sut = try makeSut(
                action: .createInstanceProperty,
                allText: text,
                selections: [highlightedText]
            )
            
            #expect(sut == [
                "class TestClass {\n",
                "\n",
                "    let someProperty = \u{003C}#Type#\u{003E}\n",
                "\n",
                "    func someDummyMethod() {\n",
                "        someProperty.callSomeMethod()\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func creatingInstancePropertyWithNoStructOrClassThrowsAndError() {
            let text = [
                "import SomeLibrary\n",
                "\n",
                "someProperty.callSomeMethod()\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!
            
            #expect(throws: TestingToolsError.noObjectToCreateInstancePropertyOn) {
                try makeSut(
                    action: .createInstanceProperty,
                    allText: text,
                    selections: [highlightedText]
                )
            }
        }
    }
    
    struct LocalPropertyTests {
        @Test func testCreatingLocalProperty() throws {
            let text = [
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!

            
            let sut = try makeSut(
                action: .createLocalProperty,
                allText: text,
                selections: [highlightedText]
            )
            
            #expect(sut == [
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            let someProperty = \u{003C}#Type#\u{003E}\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ])
        }
    }
    
    struct GlobalPropertyTests {
        @Test func testCreatingGlobalPropertyWhenThereAreImportStatements() throws {
            let text = [
                "import SomeLibrary\n",
                "\n",
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!

            let sut = try makeSut(
                action: .createGlobalProperty,
                allText: text,
                selections: [highlightedText]
            )
            
            #expect(sut == [
                "import SomeLibrary\n",
                "\n",
                "let someProperty = \u{003C}#Type#\u{003E}\n",
                "\n",
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ])
        }
        
        @Test func testCreatingGlobalPropertyWhenThereAreNoImportStatements() throws {
            let text = [
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ]
            let highlightedText = getRangeOfText("someProperty", from: text)!

            let sut = try makeSut(
                action: .createGlobalProperty,
                allText: text,
                selections: [highlightedText]
            )
            
            #expect(sut == [
                "let someProperty = \u{003C}#Type#\u{003E}\n",
                "\n",
                "struct TestStruct {\n",
                "    struct SomeNestedStruct {\n",
                "        func someDummyMethod() {\n",
                "            someProperty.callSomeMethod()\n",
                "        }\n",
                "    }\n",
                "}\n"
            ])
        }
    }
    
    struct GeneralErrorHandling {
        @Test(
            arguments: [
                Action.createLocalProperty,
                .createGlobalProperty,
                .createInstanceProperty
            ]
        )
        func testErrorIsThrownIfNoSelectionIsMade(action: Action) {
            let text = [
                "struct TestStruct {\n",
                "    someProperty.callSomeMethod()\n",
                "}\n"
            ]
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try makeSut(
                    action: action,
                    allText: text,
                    selections: []
                )
            }
        }
        
        @Test(
            arguments: [
                Action.createLocalProperty,
                .createGlobalProperty,
                .createInstanceProperty
            ]
        )
        func multipleSelectedText_throwsError(action: Action) {
            let text = [
                "struct TestStruct {\n",
                "    someProperty.callSomeMethod()\n",
                "}\n"
            ]
            let firstSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 0, column: 3)
            )
            let secondSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 5),
                end: XCSourceTextPosition(line: 0, column: 10)
            )
            
            #expect(throws: TestingToolsError.multipleSelectionNotSupported) {
                try makeSut(
                    action: action,
                    allText: text,
                    selections: [firstSelection, secondSelection]
                )
            }
        }
        
        @Test(
            arguments: [
                Action.createLocalProperty,
                .createGlobalProperty,
                .createInstanceProperty
            ]
        )
        func multipleLineSelectedText_throwsError(action: Action) {
            let text = [
                "struct TestStruct {\n",
                "    someProperty.callSomeMethod()\n",
                "}\n"
            ]
            let multipleLineSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
                try makeSut(
                    action: action,
                    allText: text,
                    selections: [multipleLineSelection]
                )
            }
        }
        
        @Test(
            arguments: [
                Action.createLocalProperty,
                .createGlobalProperty,
                .createInstanceProperty
            ]
        )
        func testOutOfBoundsLineIndex_throwsError(action: Action) {
            let text = [
                "struct TestStruct {\n",
                "    someProperty.callSomeMethod()\n",
                "}\n"
            ]
            
            // Notice "line: 4" is out of range
            let outOfBoundsSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 4, column: 0),
                end: XCSourceTextPosition(line: 4, column: 3)
            )
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try makeSut(
                    action: action,
                    allText: text,
                    selections: [outOfBoundsSelection]
                )
            }
        }
    }
}

func makeSut(action: Action, allText: [String], selections: [XCSourceTextRange]) throws -> [String] {
    try CommandActionHandler.handle(
        action: action,
        allText: allText,
        selections: selections,
        tabWidth: 4
    )
}
