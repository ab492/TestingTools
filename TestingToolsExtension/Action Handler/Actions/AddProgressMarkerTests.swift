import Testing

struct AddProgressMarkerTests {
    @Test(arguments: zip([Action.markInProgress, .markAsDone], ["⬅️", "✅"]))
    func addProgressMarkerToSingleLineWithinMultipleLines(
        action: Action,
        expectedIcon: String
    ) throws {
        let text = [
            "My first item to do\n",
            "My second item to do\n",
            "My third item to do\n"
        ]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = try makeSut(
            action: action,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do\n"
        ])
    }
    
    @Test(arguments: zip([Action.markInProgress, .markAsDone], ["⬅️", "✅"]))
    func addProgressMarkerToMultipleLines(
        action: Action,
        expectedIcon: String
    ) throws {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let secondItem = getRangeOfText("My second item to do", from: text)!
        let thirdItem = getRangeOfText("My third item to do", from: text)!
        
        let sut = try makeSut(
            action: action,
            allText: text,
            selections: [secondItem, thirdItem]
        )
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do \(expectedIcon)\n"
        ])
    }
    
    @Test(arguments: zip([Action.markInProgress, .markAsDone], ["⬅️", "✅"]))
    func addProgressMarkerToHalfSelectedLine(
        action: Action,
        expectedIcon: String
    ) throws {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("second item", from: text)!
        
        let sut = try makeSut(
            action: action,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do\n"
        ])
    }
    
    @Test func addingDoneProgressMarkerToInProgressLine_removesInProgressMarkerAndAddsDoneMarker() throws {
        let text = ["My first item to do\n", "My second item to do ⬅️\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = try makeSut(
            action: .markAsDone,
            allText: text,
            selections: [highlightedText]
        )
                
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ✅\n",
            "My third item to do\n"
        ])
    }
    
    @Test func addingInProgressMarkerToDoneLine_removesDoneMarkerAndAddsInProgressMarker() throws {
        let text = ["My first item to do\n", "My second item to do ✅\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = try makeSut(
            action: .markInProgress,
            allText: text,
            selections: [highlightedText]
        )
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do\n"
        ])
    }
}
