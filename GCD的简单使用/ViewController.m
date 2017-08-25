//
//  ViewController.m
//  GCD的简单使用
//
//  Created by 杨礼军 on 2017/8/25.
//  Copyright © 2017年 杨礼军. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    1. dispatch_queue_t queue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL); //生成一个串行队列，队列中的block按照先进先出（FIFO）的顺序去执行，实际上为单线程执行。第一个参数是队列的名称，在调试程序时会非常有用，所有尽量不要重名了。
    
//    2. dispatch_queue_t queue = dispatch_queue_create("com.dispatch.concurrent", DISPATCH_QUEUE_CONCURRENT); //生成一个并发执行队列，block被分发到多个线程去执行
    
//    3. dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //获得程序进程缺省产生的并发队列，可设定优先级来选择高、中、低三个优先级队列。由于是系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。需要注意的是，三个队列不代表三个线程，可能会有更多的线程。并发队列可以根据实际情况来自动产生合理的线程数，也可理解为dispatch队列实现了一个线程池的管理，对于程序逻辑是透明的。
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    [self dispatch_chuan];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
    [self test8];
}
//串行队列 异步任务
-(void)dispatch_chuan{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_SERIAL);
    NSLog(@"star----主线程%@",[NSThread currentThread]);
    for (int i =0; i<5; i++) {
        dispatch_async(que, ^{
            NSLog(@"async---异步线程%@",[NSThread currentThread]);
        });
    }
    NSLog(@"end-----结束线程%@",[NSThread currentThread]);
    
//    2017-08-25 17:35:39.965 GCD的简单使用[40304:752326] star----主线程<NSThread: 0x6000000753c0>{number = 1, name = main}
//    2017-08-25 17:35:39.966 GCD的简单使用[40304:752326] end-----结束线程<NSThread: 0x6000000753c0>{number = 1, name = main}
//    2017-08-25 17:35:39.966 GCD的简单使用[40304:752364] async---异步线程<NSThread: 0x600000261180>{number = 3, name = (null)}
//    2017-08-25 17:35:39.967 GCD的简单使用[40304:752364] async---异步线程<NSThread: 0x600000261180>{number = 3, name = (null)}
//    2017-08-25 17:35:39.967 GCD的简单使用[40304:752364] async---异步线程<NSThread: 0x600000261180>{number = 3, name = (null)}
//    2017-08-25 17:35:39.967 GCD的简单使用[40304:752364] async---异步线程<NSThread: 0x600000261180>{number = 3, name = (null)}
//    2017-08-25 17:35:39.967 GCD的简单使用[40304:752364] async---异步线程<NSThread: 0x600000261180>{number = 3, name = (null)}
    
//    上面代码创建了一个串行队列，然后往串行队列中添加了10个异步任务，从打印结果可以看出：先在主线程中执行打印start—，然后将异步任务添加到串行队列中（只是添加，并没有立即执行），之后在主线程打印end—，最后才会从串行队列中依次取出一个任务，并在子线程中执行，因此异步任务打印是有序的。所以， 主线程会在执行完dispatch_async方法后，立即返回执行主线程后续相关操作，主线程任务执行完毕后，才会在子线程中依次执行异步任务。由于串行队列中的任务是依次取出来执行的，即前一个任务在子线程执行完毕后，才能取出后一个任务来执行，所以只需要创建一个子线程即可。
//    结论：串行队列 异步任务，会创建子线程，且只创建一个子线程，异步任务执行是有序的。
}
//串行队列 同步任务
-(void)test2{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_SERIAL);
    NSLog(@"star ----%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_sync(que, ^{
            NSLog(@"aync ---- %@---%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end -----%@",[NSThread currentThread]);
    
//    2017-08-25 17:42:41.427 GCD的简单使用[40354:757890] star ----<NSThread: 0x60000006c080>{number = 1, name = main}
//    2017-08-25 17:42:41.427 GCD的简单使用[40354:757890] aync ---- <NSThread: 0x60000006c080>{number = 1, name = main}---0
//    2017-08-25 17:42:41.428 GCD的简单使用[40354:757890] aync ---- <NSThread: 0x60000006c080>{number = 1, name = main}---1
//    2017-08-25 17:42:41.428 GCD的简单使用[40354:757890] aync ---- <NSThread: 0x60000006c080>{number = 1, name = main}---2
//    2017-08-25 17:42:41.428 GCD的简单使用[40354:757890] aync ---- <NSThread: 0x60000006c080>{number = 1, name = main}---3
//    2017-08-25 17:42:41.428 GCD的简单使用[40354:757890] aync ---- <NSThread: 0x60000006c080>{number = 1, name = main}---4
//    2017-08-25 17:42:41.428 GCD的简单使用[40354:757890] end -----<NSThread: 0x60000006c080>{number = 1, name = main}
    
//    上面代码创建了一个串行队列，然后往串行队列中添加了10个同步任务，从打印结果可以看出：先在主线程中执行打印start—，然后在主线程依次打印同步任务，最后在主线程打印end—。所以，主线程在执行dispatch_sync方法后，并没有立刻返回，而是阻塞了当前线程，去等待dispatch_sync方法里面的block执行完毕，等到for循环里面所有同步任务执行完毕后，才返回去执行后面的end—的打印操作，所有的打印都是在主线程完成。
//        结论： 串行队列 同步任务，不创建新线程，同步任务执行是有序的。
//        问题：细心的你可能发现一个问题：既然阻塞了当前线程（主线程），为什么同步任务里面的block还能在主线程中打印？问题答案会在下一篇文章中给出。
}
//并行队列 异步任务
-(void)test3{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start------%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_async(que, ^{
            NSLog(@"async----%@----%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end -----%@",[NSThread currentThread]);
    
//    2017-08-25 17:54:18.504 GCD的简单使用[40477:769351] start------<NSThread: 0x608000073880>{number = 1, name = main}
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769351] end -----<NSThread: 0x608000073880>{number = 1, name = main}
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769408] async----<NSThread: 0x608000260e40>{number = 3, name = (null)}----0
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769409] async----<NSThread: 0x60000007e800>{number = 5, name = (null)}----2
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769461] async----<NSThread: 0x60000007e440>{number = 4, name = (null)}----1
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769411] async----<NSThread: 0x608000260e80>{number = 6, name = (null)}----3
//    2017-08-25 17:54:18.505 GCD的简单使用[40477:769464] async----<NSThread: 0x60000007e900>{number = 7, name = (null)}----4
    
//    上面代码创建了一个并行队列，然后往串行队列中添加了10个异步任务，从打印结果可以看出：先在主线程中执行打印start—，然后将异步任务添加到并行队列中（只是添加，并没有立即执行），之后立刻返回，在主线程打印end—，最后才会从并行队列中依次取出多个任务，并创建多个子线程来执行（至于创建几个子线程由系统决定），由于每个任务执行时间不同，子线程获得CPU的时间也不同，所以异步任务打印结果的顺序也不同，而且每次打印的同步任务结果都不一样。
//    结论：并行队列 异步任务 创建子线程，且多个子线程，异步任务打印结果无序
}
//并行队列 同步任务
-(void)test4{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"star--------%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_sync(que, ^{
            NSLog(@"sync ----- %@----%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end-------%@",[NSThread currentThread]);
    
//    2017-08-25 18:03:47.587 GCD的简单使用[40549:776501] star--------<NSThread: 0x600000078c00>{number = 1, name = main}
//    2017-08-25 18:03:47.587 GCD的简单使用[40549:776501] sync ----- <NSThread: 0x600000078c00>{number = 1, name = main}----0
//    2017-08-25 18:03:47.587 GCD的简单使用[40549:776501] sync ----- <NSThread: 0x600000078c00>{number = 1, name = main}----1
//    2017-08-25 18:03:47.587 GCD的简单使用[40549:776501] sync ----- <NSThread: 0x600000078c00>{number = 1, name = main}----2
//    2017-08-25 18:03:47.587 GCD的简单使用[40549:776501] sync ----- <NSThread: 0x600000078c00>{number = 1, name = main}----3
//    2017-08-25 18:03:47.588 GCD的简单使用[40549:776501] sync ----- <NSThread: 0x600000078c00>{number = 1, name = main}----4
//    2017-08-25 18:03:47.588 GCD的简单使用[40549:776501] end-------<NSThread: 0x600000078c00>{number = 1, name = main}
    
    
//    上面代码创建了一个并行队列，然后往串行队列中添加了10个同步任务，从打印结果可以看出：先在主线程中执行打印start—，然后在主线程依次打印同步任务，最后在主线程打印end—。所以，主线程在执行dispatch_sync方法后，并没有立刻返回，而是阻塞了当前线程，去等待dispatch_sync方法里面的block执行完毕，等到for循环里面所有同步任务执行完毕后，才返回去执行后面的end—的打印操作，所有的打印都是在主线程完成。
//        结论： 并行队列 同步任务，不创建新线程，同步任务执行是有序的。
//        总结上面的四种情况得出结论：
//        （1）同步、异步决定是否创建子线程，同步任务不创建子线程，都是在主线程中执行，异步任务创建子线程。
//        （2）串行、并行决定创建子线程的个数，串行创建一个子线程，并行创建多个子线程（具体几个由系统决定）。
}
//串行队列中先异步再同步
-(void)test5{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_SERIAL);
    NSLog(@"star-------%@",[NSThread currentThread]);
    for (int i = 0; i<5; i++) {
        dispatch_async(que, ^{
            NSLog(@"async-------%@----%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end1------%@",[NSThread currentThread]);
    
    for (int j=0; j<5; j++) {
        dispatch_sync(que, ^{
            NSLog(@"sync-------%@------%d",[NSThread currentThread],j);
        });
    }
    
    NSLog(@"end2--------%@",[NSThread currentThread]);
    
    
//    2017-08-25 18:14:09.200 GCD的简单使用[40639:784534] star-------<NSThread: 0x608000069ec0>{number = 1, name = main}
//    2017-08-25 18:14:09.200 GCD的简单使用[40639:784534] end1------<NSThread: 0x608000069ec0>{number = 1, name = main}
//    2017-08-25 18:14:09.200 GCD的简单使用[40639:784606] async-------<NSThread: 0x600000066d80>{number = 3, name = (null)}----0
//    2017-08-25 18:14:09.201 GCD的简单使用[40639:784606] async-------<NSThread: 0x600000066d80>{number = 3, name = (null)}----1
//    2017-08-25 18:14:09.201 GCD的简单使用[40639:784606] async-------<NSThread: 0x600000066d80>{number = 3, name = (null)}----2
//    2017-08-25 18:14:09.201 GCD的简单使用[40639:784606] async-------<NSThread: 0x600000066d80>{number = 3, name = (null)}----3
//    2017-08-25 18:14:09.201 GCD的简单使用[40639:784606] async-------<NSThread: 0x600000066d80>{number = 3, name = (null)}----4
//    2017-08-25 18:14:09.201 GCD的简单使用[40639:784534] sync-------<NSThread: 0x608000069ec0>{number = 1, name = main}------0
//    2017-08-25 18:14:09.202 GCD的简单使用[40639:784534] sync-------<NSThread: 0x608000069ec0>{number = 1, name = main}------1
//    2017-08-25 18:14:09.202 GCD的简单使用[40639:784534] sync-------<NSThread: 0x608000069ec0>{number = 1, name = main}------2
//    2017-08-25 18:14:09.219 GCD的简单使用[40639:784534] sync-------<NSThread: 0x608000069ec0>{number = 1, name = main}------3
//    2017-08-25 18:14:09.219 GCD的简单使用[40639:784534] sync-------<NSThread: 0x608000069ec0>{number = 1, name = main}------4
//    2017-08-25 18:14:09.219 GCD的简单使用[40639:784534] end2--------<NSThread: 0x608000069ec0>{number = 1, name = main}
    
//    此时创建一个子线程开始依次执行异步任务，异步任务结束后，在主线程中执行同步任务（上面的结论）。1个同步任务执行完后（此时串行队列里没有任务了），主线程返回，for循环继续往串行队列里添加1个同步任务，此时主线程继续阻塞，等待串行队列里同步任务执行完毕，此时主线程执行这个同步任务，执行完毕后，主线程返回继续for循环……。等for循环结束后，最后在主线程执行打印end2—的操作。 
}
//串行队列中先同步再异步
-(void)test6{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_SERIAL);
    NSLog(@"star--------%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_sync(que, ^{
            NSLog(@"sync-------%@-----%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end1----------%@",[NSThread currentThread]);
    
    for (int j=0; j<5; j++) {
        dispatch_async(que, ^{
            NSLog(@"async-------%@------%d",[NSThread currentThread],j);
        });
    }
    
    NSLog(@"end2----------%@",[NSThread currentThread]);
    
//    2017-08-25 18:23:19.478 GCD的简单使用[40804:792922] star--------<NSThread: 0x6000000725c0>{number = 1, name = main}
//    2017-08-25 18:23:19.479 GCD的简单使用[40804:792922] sync-------<NSThread: 0x6000000725c0>{number = 1, name = main}-----0
//    2017-08-25 18:23:19.480 GCD的简单使用[40804:792922] sync-------<NSThread: 0x6000000725c0>{number = 1, name = main}-----1
//    2017-08-25 18:23:19.480 GCD的简单使用[40804:792922] sync-------<NSThread: 0x6000000725c0>{number = 1, name = main}-----2
//    2017-08-25 18:23:19.480 GCD的简单使用[40804:792922] sync-------<NSThread: 0x6000000725c0>{number = 1, name = main}-----3
//    2017-08-25 18:23:19.481 GCD的简单使用[40804:792922] sync-------<NSThread: 0x6000000725c0>{number = 1, name = main}-----4
//    2017-08-25 18:23:19.481 GCD的简单使用[40804:792922] end1----------<NSThread: 0x6000000725c0>{number = 1, name = main}
//    2017-08-25 18:23:19.482 GCD的简单使用[40804:793011] async-------<NSThread: 0x600000079d80>{number = 3, name = (null)}------0
//    2017-08-25 18:23:19.482 GCD的简单使用[40804:793011] async-------<NSThread: 0x600000079d80>{number = 3, name = (null)}------1
//    2017-08-25 18:23:19.482 GCD的简单使用[40804:792922] end2----------<NSThread: 0x6000000725c0>{number = 1, name = main}
//    2017-08-25 18:23:19.482 GCD的简单使用[40804:793011] async-------<NSThread: 0x600000079d80>{number = 3, name = (null)}------2
//    2017-08-25 18:23:19.482 GCD的简单使用[40804:793011] async-------<NSThread: 0x600000079d80>{number = 3, name = (null)}------3
//    2017-08-25 18:23:19.483 GCD的简单使用[40804:793011] async-------<NSThread: 0x600000079d80>{number = 3, name = (null)}------4
    
//    上面代码创建了一个串行队列，然后往串行队列中添加了10个同步任务，再添加10个异步任务，从打印结果可以看出：先在主线程中执行打印start—，然后往串行队列里添加了1个同步任务，此时主线程堵塞，等待串行队列里地同步任务执行完毕。此时创建一个子线程开始依次执行串行队列的任务，在主线程中执行同步任务（上面的结论）。1个同步任务执行完后（此时串行队列里没有任务了），主线程返回，for循环继续往串行队列里添加1个同步任务，此时主线程继续阻塞，等待串行队列里同步任务执行完毕，此时主线程执行这个同步任务，执行完毕后，主线程返回继续for循环……。等for循环结束后，在主线程打印end1—，然后执行到dispatch_async往串行队列里添加异步任务，并立即返回，for循环结束后，串行队列里有10个异步任务，此时主线程继续往下执行打印end2—的操作。之后开始创建子线程依次执行串行队列里地异步任务。
}
//并行队列中先异步再同步
-(void)test7{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"star------------%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_async(que, ^{
            NSLog(@"asunc-------%@------%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end1--------%@",[NSThread currentThread]);
    for (int j=0; j<5; j++) {
        dispatch_sync(que, ^{
            NSLog(@"sync--------%@,-------%d",[NSThread currentThread],j);
        });
    }
    NSLog(@"end2--------%@",[NSThread currentThread]);
    
//    2017-08-25 18:30:45.643 GCD的简单使用[40864:798251] star------------<NSThread: 0x600000068280>{number = 1, name = main}
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798251] end1--------<NSThread: 0x600000068280>{number = 1, name = main}
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798337] asunc-------<NSThread: 0x600000070980>{number = 4, name = (null)}------1
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798338] asunc-------<NSThread: 0x600000070a80>{number = 3, name = (null)}------0
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798356] asunc-------<NSThread: 0x600000070ac0>{number = 5, name = (null)}------2
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798251] sync--------<NSThread: 0x600000068280>{number = 1, name = main},-------0
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798340] asunc-------<NSThread: 0x600000070a40>{number = 6, name = (null)}------3
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798337] asunc-------<NSThread: 0x600000070980>{number = 4, name = (null)}------4
//    2017-08-25 18:30:45.644 GCD的简单使用[40864:798251] sync--------<NSThread: 0x600000068280>{number = 1, name = main},-------1
//    2017-08-25 18:30:45.673 GCD的简单使用[40864:798251] sync--------<NSThread: 0x600000068280>{number = 1, name = main},-------2
//    2017-08-25 18:30:45.673 GCD的简单使用[40864:798251] sync--------<NSThread: 0x600000068280>{number = 1, name = main},-------3
//    2017-08-25 18:30:45.674 GCD的简单使用[40864:798251] sync--------<NSThread: 0x600000068280>{number = 1, name = main},-------4
//    2017-08-25 18:30:45.674 GCD的简单使用[40864:798251] end2--------<NSThread: 0x600000068280>{number = 1, name = main}
//    上面代码创建了一个并行队列，然后往并行队列中添加了10个异步任务和10个同步任务，上面只是某一次的打印结果，每次的打印结果都不一样，从打印结果可以看出：由于是并行队列，会开启多个子线程执行异步任务，所以异步任务的打印结果是无序的，而同步任务由于都是在主线程中执行，所有总体是有序的。而且同步与异步任务是交叉着执行完毕的。 
}
//并行队列中先同步再异步
-(void)test8{
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"star-----%@",[NSThread currentThread]);
    for (int i=0; i<5; i++) {
        dispatch_sync(que, ^{
            NSLog(@"sync---------%@,-------%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"end1----------%@",[NSThread currentThread]);
    
    for (int j=0; j<5; j++) {
        dispatch_async(que, ^{
            NSLog(@"async ---------%@,-------%d",[NSThread currentThread],j);
        });
    }
    NSLog(@"end2----------%@",[NSThread currentThread]);
    
//    2017-08-25 18:39:03.823 GCD的简单使用[40908:804263] star-----<NSThread: 0x608000068f40>{number = 1, name = main}
//    2017-08-25 18:39:03.823 GCD的简单使用[40908:804263] sync---------<NSThread: 0x608000068f40>{number = 1, name = main},-------0
//    2017-08-25 18:39:03.823 GCD的简单使用[40908:804263] sync---------<NSThread: 0x608000068f40>{number = 1, name = main},-------1
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804263] sync---------<NSThread: 0x608000068f40>{number = 1, name = main},-------2
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804263] sync---------<NSThread: 0x608000068f40>{number = 1, name = main},-------3
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804263] sync---------<NSThread: 0x608000068f40>{number = 1, name = main},-------4
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804263] end1----------<NSThread: 0x608000068f40>{number = 1, name = main}
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804263] end2----------<NSThread: 0x608000068f40>{number = 1, name = main}
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804312] async ---------<NSThread: 0x608000073880>{number = 3, name = (null)},-------0
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804329] async ---------<NSThread: 0x600000074440>{number = 4, name = (null)},-------1
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804311] async ---------<NSThread: 0x6080000737c0>{number = 5, name = (null)},-------2
//    2017-08-25 18:39:03.824 GCD的简单使用[40908:804314] async ---------<NSThread: 0x6080000738c0>{number = 6, name = (null)},-------3
//    2017-08-25 18:39:03.825 GCD的简单使用[40908:804331] async ---------<NSThread: 0x608000073800>{number = 7, name = (null)},-------4
    
//    都是先有序的执行完同步任务，再无序的执行异步任务。没有交叉执行完的想象，原因在于先添加的同步任务，没添加一个同步任务会堵塞主线程，等待同步任务执行完毕，所以会依次在主线程执行同步任务，for循环结束后，此时并行队列里为空，之后再往并行队列中添加了10个异步任务，此时没有堵塞主线程，主线程一直往下执行打印end2—，此时开启多个子线程来执行执行异步任务，所以执行完的顺序是未知的。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
