import Testing

struct EnhanceObjectTests {

    @Test func testCreatingIntPropertyOnStructDefinedOnOneLine() throws {
        let text = [
            "struct MyStruct { }\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myString.intProperty = 4",
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
            "        myString.intProperty = 4",
            "    }\n",
            "}\n"
        ])
    }
    
    @Test func testCreatingStringPropertyOnStructDefinedAcrossMultipleLines() throws {
        let text = [
            "struct MyStruct {\n",
            "    let somePreExistingProperty: String\n",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myString.stringProperty = \"String property\"",
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
            "    let stringProperty: String",
            "}\n",
            "\n",
            "struct SomeTestFile {\n",
            "    func testSomething() {\n",
            "        let myStruct = MyStruct()\n",
            "        myString.stringProperty = \"String property\"",
            "    }\n",
            "}\n"
        ])
    }
}
