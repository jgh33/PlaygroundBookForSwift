//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code
//:本章我们将从struct入手来了解struct的内存模型以及一些问题
//:创建一个struct，如下
enum Sex {
    case man
    case woman
}
struct Person {
    var id: Int
    var age: Int
    var sex: Sex
}
//:让它包含一个两个Int和一个enum
let size = MemoryLayout<Person>.size
let stride = MemoryLayout<Person>.stride
let alignment = MemoryLayout<Person>.alignment
//:用MemoryLayout查看一下内存大小。size17，stride24, alignment8.完全符合预期的值。
//:突发奇想，仍旧用相同的属性，但这次的顺序是Int，Sex，Int
struct NewPerson {
    var id: Int
    var sex: Sex
    var age: Int
}
let sizeNew = MemoryLayout<NewPerson>.size
let strideNew = MemoryLayout<NewPerson>.stride
let alignmentNew = MemoryLayout<NewPerson>.alignment
//:用MemoryLayout查看一下内存大小。size24，stride24, alignment8.
//:这里数据就有点不太符合预期了。预期size为8+1+8=17,为什么会是24呢？
var newPerson = NewPerson(id: 5, sex: .man, age: Int.max)
print(UnsafePointer(&newPerson))
//:仍旧实用lldb命令查看一下：x/24wb 0x1111111
//0x05 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0xff 0xff 0xff 0xff 0xff 0xff 0xff 0x7f
//:可以看到前8字节数据为5，符合预期，后8字节为Int.max,中间8个字节用来表示enum的case（准确来说1字节+7个补位字节）。但为什么会是用8个字节而不是1个字节来表示enum的case呢。
//:这里我大胆猜测一下，如果用1个字节，后边不加补位字节，直接跟下一个属性的Int的话，会造成age的Int数据本身无法8字节对齐，故将补位字节放在了enum这里。
