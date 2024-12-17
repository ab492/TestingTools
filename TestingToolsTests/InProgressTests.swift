//
//  InProgressTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 17/12/2024.
//

import Testing

struct InProgressTests {
    @Test func markSingleLineWithinMultipleLinesAsInProgress_addsCorrectEmoji() {
        let text = ["My first item to do", "My second item to do", "My third item to do"]
        let highlightedText = getRangeOfText("My second item to do", from: text)!
        
        let sut = markInProgress(allText: text, selectedText: highlightedText)
        
        #expect(sut == [
            "My first item to do",
            "My second item to do ⬅️",
            "My third item to do"
        ])
    }
    
    @Test func markMultipleLinesAsInProgress_addsCorrectEmoji() {
        let text = ["My first item to do", "My second item to do", "My third item to do"]
        let secondItem = getRangeOfText("My second item to do", from: text)!
        let thirdItem = getRangeOfText("My third item to do", from: text)!


    }


}

// Mark one line in progress ✅
// Mark multiple lines in progress/done
// Selecting line from the middle still highlight the whole line
// Don't add icon if it's already been added
