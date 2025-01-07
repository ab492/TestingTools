import Testing
import XcodeKit
@testable import TestingTools


struct CreatePropertyTests {
    
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

        
        let sut = try CommandActionHandler.handle(
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
    
    @Test func testErrorIsThrownIfNoSelectionIsMade() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        
        #expect(throws: TestingToolsError.invalidSelection) {
            try CommandActionHandler.handle(
                action: .createLocalProperty,
                allText: text,
                selections: []
            )
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
            try CommandActionHandler.handle(
                action: .createLocalProperty,
                allText: text,
                selections: [firstSelection, secondSelection]
            )
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
            try CommandActionHandler.handle(
                action: .createLocalProperty,
                allText: text,
                selections: [multipleLineSelection]
            )
        }
    }
}
