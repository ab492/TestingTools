import Testing
@testable import TestingTools

struct ActionTests {
    @Test func testRawValueForCreateStructIsCorrect() async throws {
        let rawValue = Action.createStruct.rawValue
        
        #expect(rawValue == "testingtools.createStruct")
    }
    
    @Test func testInitFromRawValueWorksCorrectlyForCreateStruct() async throws {
        let action = Action(rawValue: "testingtools.createStruct")
        
        #expect(action == .createStruct)
    }
}
