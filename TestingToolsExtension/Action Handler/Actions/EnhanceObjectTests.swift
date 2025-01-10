import Testing

// TODO
// Make the initial test case simpler for easier refactoring ⬅️
// Handle let/var definitions
struct EnhanceObjectTests {
    
    @Test func testCreatingIntPropertyOnStructDefinedOnOneLine() throws {
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
}

//    @Test func testCreatingStringPropertyOnStructDefinedAcrossMultipleLines() throws {
//        let text = [
//            "struct MyStruct {\n",
//            "    let somePreExistingProperty: String\n",
//            "}\n",
//            "\n",
//            "struct SomeTestFile {\n",
//            "    func testSomething() {\n",
//            "        let myStruct = MyStruct()\n",
//            "        myStruct.stringProperty = \"String property\"",
//            "    }\n",
//            "}\n"
//        ]
//        let highlightedText = getRangeOfText("stringProperty", from: text)!
//
//        
//        let sut = try makeSut(
//            action: .addPropertyToObject,
//            allText: text,
//            selections: [highlightedText]
//        )
//        
//        #expect(sut == [
//            "struct MyStruct {\n",
//            "    let somePreExistingProperty: String\n",
//            "    let stringProperty: String",
//            "}\n",
//            "\n",
//            "struct SomeTestFile {\n",
//            "    func testSomething() {\n",
//            "        let myStruct = MyStruct()\n",
//            "        myStruct.stringProperty = \"String property\"",
//            "    }\n",
//            "}\n"
//        ])
//    }
//    
//    @Test func testCreatingBoolPropertyOnClassDefinedAcrossMultipleLines() throws {
//        let text = [
//            "class SomeClassName {\n",
//            "    \n",
//            "    let somePreExistingProperty: String\n",
//            "}\n",
//            "\n",
//            "struct SomeTestFile {\n",
//            "    func testSomething() {\n",
//            "        let myClass = SomeClassName()\n",
//            "        myClass.boolProperty = true\n",
//            "    }\n",
//            "}\n"
//        ]
//        let highlightedText = getRangeOfText("boolProperty", from: text)!
//
//        
//        let sut = try makeSut(
//            action: .addPropertyToObject,
//            allText: text,
//            selections: [highlightedText]
//        )
//        
//        #expect(sut == [
//            "class SomeClassName {\n",
//            "    \n",
//            "    let somePreExistingProperty: String\n",
//            "    let boolProperty: Bool\n",
//            "}\n",
//            "\n",
//            "struct SomeTestFile {\n",
//            "    func testSomething() {\n",
//            "        let myClass = SomeClassName()\n",
//            "        myClass.boolProperty = true\n",
//            "    }\n",
//            "}\n"
//        ])
//    }
//}
