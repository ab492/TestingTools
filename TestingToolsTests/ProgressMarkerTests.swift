import Testing

struct ProgressMarkerTests {
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
        
        let sut = try CommandActionHandler.handle(
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
    
    @Test(arguments: zip([ProgressMarker.inProgress, .done], ["⬅️", "✅"]))
    func addProgressMarkerToMultipleLines(
        progressMarker: ProgressMarker,
        expectedIcon: String
    ) {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let secondItem = getRangeOfText("My second item to do", from: text)!
        let thirdItem = getRangeOfText("My third item to do", from: text)!
        
        let sut = addProgressMarker(progressMarker, allText: text, selectedText: [secondItem, thirdItem])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do \(expectedIcon)\n"
        ])
    }
    
    @Test(arguments: zip([ProgressMarker.inProgress, .done], ["⬅️", "✅"]))
    func addProgressMarkerToHalfSelectedLine(
        progressMarker: ProgressMarker,
        expectedIcon: String
    ) {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("second item", from: text)!
        
        let sut = addProgressMarker(progressMarker, allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do\n"
        ])
    }
    
    @Test func addingDoneProgressMarkerToInProgressLine_removesInProgressMarkerAndAddsDoneMarker() {
        let text = ["My first item to do\n", "My second item to do ⬅️\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = addProgressMarker(.done, allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ✅\n",
            "My third item to do\n"
        ])
    }
    
    @Test func addingInProgressMarkerToDoneLine_removesDoneMarkerAndAddsInProgressMarker() {
        let text = ["My first item to do\n", "My second item to do ✅\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = addProgressMarker(.inProgress, allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do\n"
        ])
    }
    
}
