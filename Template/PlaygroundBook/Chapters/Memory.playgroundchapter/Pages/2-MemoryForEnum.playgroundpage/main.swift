//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code
//:#这一节我们讲解一下几个自定义的类型，enum
//:让我们定义一个enum
enum Season {
    case spring
    case summer
    case autumn
    case winter
}
//:我们再看一下Season的内存情况
let size = MemoryLayout<Season>.size
let stride = MemoryLayout<Season>.stride
let alignment = MemoryLayout<Season>.alignment
//:通过视图检查器可以看到，三个值都是1（字节）
//:为什么会是1呢？我们做一个实验，因为这个实验需要用到lldb调试工具，所以暂时只能通过XCode来做
var season = Season.spring
print(UnsafePointer(&season))
season = .summer
season = .autumn
season = .winter
//:1,实例化一个对象，并设置初始值为spring
//:2,打印一下season的地址指针
//:3,分别修改season的值为其他值
//:4,在print函数的下一行设置断点
//:5,运行XCode项目，debug区域打印出了season的指针地址,此处假设地址为0x16bb56fd7
//:6,因为已知Season的size以及stride都是1，所以就用lldb工具打印出该地址所指向的内存区域的值x/1xb 0x16bb56fd7
//:7,此时看到打印的结果0x00
//:8,接下来单步执行代码，然后继续通过lldb的命令打印内存值，看到值分别为0x01，0x02, 0x03
//:因次，我们猜测，对于该Season的对象，仅仅是通过0到255之间的值来区分不同的case而已，而且应该是从上往下一次加1.

//:#考虑到enum还可以绑定类型，因此我们再做一次相同的实验，但是这次创建一个IntSeason继承Int
enum IntSeason: Int {
    case spring
    case summer
    case autumn
    case winter
}
let sizeInt = MemoryLayout<IntSeason>.size
let strideInt = MemoryLayout<IntSeason>.stride
let alignmentInt = MemoryLayout<IntSeason>.alignment
//:实验结果同Season完全一样，3个值都是1，而且实例对象仍旧是0，1，2，3
//:#我们以下面的配置再做一次相同的实验，
enum NewIntSeason: Int {
    case spring = 3
    case summer = 5
    case autumn = 1000
    case winter = 4
}
let sizeIntNew = MemoryLayout<NewIntSeason>.size
let strideIntNew = MemoryLayout<NewIntSeason>.stride
let alignmentIntNew = MemoryLayout<NewIntSeason>.alignment
//:我在想，现在这次autumn的值是1000，大于了255，那应该一个字节无法存储了吧。
//:结果3个值依然是1，打了我的脸。那为什么会是这样子的。依然通过lldb的命令查看了每个季节的内存值，0，1，2，3。
//:仔细想想，确实不需要去考虑对应的value，我们只需要见每个case分开即可。当我们需要拿到这个value的时候会通过.rawValue去拿。我大胆猜测，这是一个计算属性，做一次maping即可。那么，season实例就不需要携带对应的rawValue了。
//:#考虑到enum还可以绑定具体的值，因此我们再做一次相同的实验，但是这次创建一个BindingEnum

enum BindingEnum {
    case one(Int)
    case two(Int, Int)
    case three(Int, Bool, Bool)
}
let sizeBinding = MemoryLayout<BindingEnum>.size
let strideBinding = MemoryLayout<BindingEnum>.stride
let alignmentBinding = MemoryLayout<BindingEnum>.alignment
//:得到的结果终于有点意外了。size = 17，stride = 24，alignment = 8
//:让我们分析一下，case one是一个Int类型，上一页已经求证过了，8字节。case two是2x8=16，case three是8+1+1=10.然后对比一下，得到的结果size是17，而不是size最大的16.为什么呢？对了，区分不同case还需要1字节的内存，刚好等于17.但是struct是8字节对齐，所以，分配内存就是3x8=24.完美。
//:他的内存结构是如何呢？我采用相同的lldb命令方法去验证一下，这次由于是17个有效字节。所以命令为x/17xb 0x1111
var binding = BindingEnum.one(255)
print(UnsafePointer(&binding))
binding = .two(255, 255)
binding = .three(255, true, false)
//得到的结果分别是
//case one(255)
//0xff 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0x00
//
//case two(255,255)
//0xff 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0xff 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0x01
//
//case three(255, true, true)
//0xff 0x00 0x00 0x00 0x00 0x00 0x00 0x00
//0x01 0x01 0x00 0x00 0x00 0x00 0x00 0x00
//0x02
//:看最后一个字节，刚好是0，1，2，是用来区分case的；
//然后就很明了的知道case one使用了前8个字节来存储255；case two实用前16个字节来存储两个255；case three用前8个字节存储255,9-10字节分别存储两个true
