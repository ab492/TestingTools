import Testing
import XcodeKit

struct CommandActionHandlerTests {
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



