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

}

private func makeSut(allText: [String], selections: [XCSourceTextRange]) throws -> [String] {
    try CommandActionHandler.handle(
        action: .createGlobalProperty,
        allText: allText,
        selections: selections
    )
}
