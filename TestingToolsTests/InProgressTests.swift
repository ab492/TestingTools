//
//  InProgressTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 17/12/2024.
//

import Testing

struct InProgressTests {
    @Test func markSingleLineWithinMultipleLinesAsInProgress_addsCorrectEmoji() {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = markInProgress(allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do\n"
        ])
    }
    
    @Test func markMultipleLinesAsInProgress_addsCorrectEmoji() {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let secondItem = getRangeOfText("My second item to do", from: text)!
        let thirdItem = getRangeOfText("My third item to do", from: text)!
        
        let sut = markInProgress(allText: text, selectedText: [secondItem, thirdItem])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do ⬅️\n"
        ])
    }
    
    @Test func selectingLineFromMiddleAndMarkingInProgress_addsCorrectEmoji() {
        let text = ["My first item to do\n", "My second item to do\n", "My third item to do\n"]
        let highlightedText = getRangeOfText("second item", from: text)!
        
        let sut = markInProgress(allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "My first item to do\n",
            "My second item to do ⬅️\n",
            "My third item to do\n"
        ])
    }
}

// Mark one line in progress ✅ ⬅️
// Mark multiple lines in progress/done ✅ ⬅️
// Selecting line from the middle still highlight the whole line ⬅️
// Don't add icon if it's already been added ⬅️
