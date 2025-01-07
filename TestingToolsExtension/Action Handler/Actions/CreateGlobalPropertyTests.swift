import Testing
import XcodeKit

struct CreateGlobalPropertyTests {

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

        let sut = try makeSut(allText: text, selections: [highlightedText])
        
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

        let sut = try makeSut(allText: text, selections: [highlightedText])
        
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
    
    @Test func testErrorIsThrownIfNoSelectionIsMade() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        
        #expect(throws: TestingToolsError.invalidSelection) {
            try makeSut(allText: text, selections: [])
        }
    }
    
    @Test func multipleSelectedText_throwsError() {
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
            try makeSut(allText: text, selections: [firstSelection, secondSelection])
        }
    }
    
    @Test func multipleLineSelectedText_throwsError() {
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
            try makeSut(allText: text, selections: [multipleLineSelection])
        }
    }
    
    @Test func testOutOfBoundsLineIndex_throwsError() {
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
            try makeSut(allText: text, selections: [outOfBoundsSelection])
        }
    }
}

private func makeSut(allText: [String], selections: [XCSourceTextRange]) throws -> [String] {
    try CommandActionHandler.handle(
        action: .createGlobalProperty,
        allText: allText,
        selections: selections
    )
}
