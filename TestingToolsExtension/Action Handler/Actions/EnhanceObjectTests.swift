import Testing

struct EnhanceObjectTests {

    @Test func testCreatingPropertyOnObject() throws {
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
}
