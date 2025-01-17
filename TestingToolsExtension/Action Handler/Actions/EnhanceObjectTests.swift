import Testing
import XcodeKit
// TODO
// Make the initial test case simpler for easier refactoring ✅
// Handle let/var definitions ✅
// More property types ✅
// object wit init - PUNT THIS ONE (MAYBE ADD AN ERROR CASE?)
// object elsewhere in file ✅
// Error cases ✅
// REFACTOR! ⬅️
struct EnhanceObjectTests {
    
    @Test func creatingIntPropertyOnStructDefinedOnOneLine() throws {
        let text = [
            "struct MyStruct { }\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.intProperty = 4",
            "    }\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("intProperty", from: text)!
        
        
        let sut = try makeSut(
            action: .addPropertyToObject,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "struct MyStruct {\n",
            "    let intProperty: Int\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.intProperty = 4",
            "    }\n",
            "}\n"
        ])
    }
    
    @Test func creatingStringPropertyOnStructDefinedAcrossMultipleLines() throws {
        let text = [
            "struct MyStruct {\n",
            "    let somePreExistingProperty: String\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.stringProperty = \"String property\"",
            "    }\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("stringProperty", from: text)!
        
        
        let sut = try makeSut(
            action: .addPropertyToObject,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "struct MyStruct {\n",
            "    let somePreExistingProperty: String\n",
            "    let stringProperty: String\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.stringProperty = \"String property\"",
            "    }\n",
            "}\n"
        ])
    }
    
    @Test func creatingBoolPropertyOnClassDefinedAcrossMultipleLines() throws {
        let text = [
            "class SomeClassName {\n",
            "\n",
            "    var somePreExistingProperty: String\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myClass = SomeClassName()\n",
            "        myClass.boolProperty = true\n",
            "    }\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("boolProperty", from: text)!
        
        
        let sut = try makeSut(
            action: .addPropertyToObject,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "class SomeClassName {\n",
            "\n",
            "    var somePreExistingProperty: String\n",
            "    let boolProperty: Bool\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myClass = SomeClassName()\n",
            "        myClass.boolProperty = true\n",
            "    }\n",
            "}\n"
        ])
    }
    
    @Test func creatingDoublePropertyOnClassAtBottomOfFile() throws {
        let text = [
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myClass = SomeClassName()\n",
            "        myClass.doubleProperty = 3.14\n",
            "    }\n",
            "}\n",
            "class SomeClassName {\n",
            "\n",
            "    var somePreExistingProperty: String\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("doubleProperty", from: text)!
        
        
        let sut = try makeSut(
            action: .addPropertyToObject,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myClass = SomeClassName()\n",
            "        myClass.doubleProperty = 3.14\n",
            "    }\n",
            "}\n",
            "class SomeClassName {\n",
            "\n",
            "    var somePreExistingProperty: String\n",
            "    let doubleProperty: Double\n",
            "}\n"
        ])
    }
    
    @Test
    func creatingUnknownPropertyTypeOnStruct() throws {
        let text = [
            "struct MyStruct { }\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.unknownProperty = someUnknownObject\n",
            "    }\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("unknownProperty", from: text)!
        
        
        let sut = try makeSut(
            action: .addPropertyToObject,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "struct MyStruct {\n",
            "    let unknownProperty: \u{003C}#Type#\u{003E}\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myStruct.unknownProperty = someUnknownObject\n",
            "    }\n",
            "}\n"
        ])
    }
    
    struct ErrorHandling {
        @Test func errorIsThrownIfNoSelectionIsMade() {
            let text = [
                "struct MyStruct { }\n",
                "\n",
                "struct SomeTestFile {\n",
                "    func testSomething() {\n",
                "        let myStruct = MyStruct()\n",
                "        myStruct.intProperty = 4",
                "    }\n",
                "}\n"
            ]
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try makeSut(
                    action: .addPropertyToObject,
                    allText: text,
                    selections: []
                )
            }
        }
        
        @Test func multipleSelectedText_throwsError() {
            let text = [
                "struct MyStruct { }\n",
                "\n",
                "struct SomeTestFile {\n",
                "    func testSomething() {\n",
                "        let myStruct = MyStruct()\n",
                "        myStruct.intProperty = 4",
                "    }\n",
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
                    action: .addPropertyToObject,
                    allText: text,
                    selections: [firstSelection, secondSelection]
                )
            }
        }
        
        @Test func multipleLineSelectedText_throwsError() {
            let text = [
                "struct MyStruct { }\n",
                "\n",
                "struct SomeTestFile {\n",
                "    func testSomething() {\n",
                "        let myStruct = MyStruct()\n",
                "        myStruct.intProperty = 4",
                "    }\n",
                "}\n"
            ]
            let multipleLineSelection = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 0),
                end: XCSourceTextPosition(line: 1, column: 10)
            )
            
            #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
                try makeSut(
                    action: .addPropertyToObject,
                    allText: text,
                    selections: [multipleLineSelection]
                )
            }
        }
        
        @Test func outOfBoundsLineIndex_throwsError() {
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
                    action: .addPropertyToObject,
                    allText: text,
                    selections: [outOfBoundsSelection]
                )
            }
        }
    }
}
