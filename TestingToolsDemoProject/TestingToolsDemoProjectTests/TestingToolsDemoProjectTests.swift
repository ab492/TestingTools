import Foundation
import Testing

let rectangle = Rectangle(width: 5, height: 2)

func test() {
    #expect(rectangle.area == 10)
}

struct Rectangle {
    let width: Int
    let height: Int
    
    var area: Int { width * height }
}
