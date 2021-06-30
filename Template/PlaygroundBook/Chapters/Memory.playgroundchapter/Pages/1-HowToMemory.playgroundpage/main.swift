//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code
//:#如何查看一个对象占用的内存大小
//:Swift给我们提供了一个叫做MemoryLayout<T>的enum,很显然这是个支持泛型的enum。
//:MemoryLayout有3个Int类型的只读属性，分别是size，stride，alignment
//:-size:实际占用内存的大小
//:-stride:系统分配的内存大小
//:-alignment:内存的对其参数
//:这里就要给大家普及一下内存对齐的知识了
//:通过MemoryLayout，我们就可以知道一个类型所占据的内存大小了
//:让我们用一个最简单的例子演示一下
//:let size = MemoryLayout<Int>.size
//:let stride = MemoryLayout<Int>.stride
//:let alignment = MemoryLayout<Int>.alignment
let size = MemoryLayout<Int>.size
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
//:通过视图检查器可以看到，三个值都是8（字节）
//:分析一下，Int在64位系统下，是64bit（位），刚好就是8Byte（字节）。故size位8；
//:而在当前系统下，系统为Int类型采用的是8字节对齐,alignment表示的就是系统为Int类型的内存对齐方式。
//:因次，系统只需要给Int分配8字节内存就够了。
//:我们继续试一下Bool类型
//:let size1 = MemoryLayout<Bool>.size
//:let stride1 = MemoryLayout<Bool>.stride
//:let alignment1 = MemoryLayout<Bool>.alignment
let size1 = MemoryLayout<Bool>.size
let stride1 = MemoryLayout<Bool>.stride
let alignment1 = MemoryLayout<Bool>.alignment

//:大家如果有兴趣的话，可以继续看一下String，Double，Float


