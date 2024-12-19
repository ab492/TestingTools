let sut = MyStruct(someString: "Hello")


struct MyStruct {
    let someString: String
}

let sut2 = MyClass(something: sut, someInt: 4)

class MyClass {
    let something: MyStruct
    let someInt: Int

    init(something: MyStruct, someInt: Int) {
        self.something = something
        self.someInt = someInt
    }
}

// My first item
// My second item
// My third item
 ⬅️
