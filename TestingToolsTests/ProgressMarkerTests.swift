import Testing

struct ProgressMarkerTests {
    @Test(arguments: zip([ProgressMarker.inProgress, .done], ["⬅️", "✅"]))
    func addProgressMarkerToSingleLineWithinMultipleLines(
        progressMarker: ProgressMarker,
        expectedIcon: String
    ) {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = addProgressMarker(progressMarker, allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do \(expectedIcon)\n",
            "My third item to do\n"
        ])
    }
    
    @Test func addProgressMarkerToMultipleLines() {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let secondItem = getRangeOfText("My second item to do", from: text)!
        let thirdItem = getRangeOfText("My third item to do", from: text)!
        
        let sut = addProgressMarker(.inProgress, allText: text, selectedText: [secondItem, thirdItem])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do ⬅️\n"
        ])
    }
    
    @Test func addProgressMarkerToHalfSelectedLine() {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("second item", from: text)!
        
        let sut = addProgressMarker(.inProgress, allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do\n"
        ])
    }
}
