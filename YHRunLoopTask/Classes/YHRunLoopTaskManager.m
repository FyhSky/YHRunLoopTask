//
//  YHRunLoopTaskManager.m
//  YHRunLoopTask
//
//  Created by FengYinghao on 2020/5/6.
//

#import "YHRunLoopTaskManager.h"
#import "YHRunLoopTask.h"

@interface YHRunLoopTaskManager() {
    CFRunLoopRef _runloop;
    CFRunLoopSourceRef _source0;
}

@property (nonatomic, strong) NSMutableArray <YHRunLoopTask *> *tasks;

@property (nonatomic, strong) YHRunLoopTask *currentExecuteTask;

@property (nonatomic, assign, getter=isSuspend) BOOL suspend;

@property (nonatomic, strong) YHRunLoopTask *executetTask;
@end

@implementation YHRunLoopTaskManager
- (void)addTask:(YHRunLoopTask *)taskUnit {
    [self.tasks addObject:taskUnit];
    if (self.tasks.count > _maximumTaskCount && self.tasks.count > 0) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)removeTask:(YHRunLoopTask *)taskUnit {
    [self removeTaskForIdentifier:taskUnit.identifier];
}

- (void)addTask:(RunLoopTask)task forIdentifier:(NSString *)identifier {
    YHRunLoopTask *taskUnit = [[YHRunLoopTask alloc] initTaskUnit:task forIdentifier:identifier];
    [self addTask:taskUnit];
}

- (void)removeTaskForIdentifier:(NSString *)identifier {
    [self.tasks enumerateObjectsUsingBlock:^(YHRunLoopTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![task isEqual:self.currentExecuteTask] && [task.identifier isEqualToString:identifier]) {
            [self.tasks removeObject:task];
        }
    }];
}

- (void)removeAllTaskUnit {
    [self.tasks enumerateObjectsUsingBlock:^(YHRunLoopTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![task isEqual:self.currentExecuteTask]) {
            [self.tasks removeObject:task];
        }
    }];
}

- (void)suspend {
    if (!self.isSuspend) {
        self.suspend = YES;
    }
}

- (void)resume {
    if (self.isSuspend) {
        self.suspend = NO;
    }
}

- (void)registerRunloopForObserver:(YHRunLoopTaskManager *)instance {
    instance->_runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = { .version = 0, .info = (__bridge void *)instance, &CFRetain, &CFRelease, NULL };
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, YES, 0, runLoopOberverCallback, &context);
    CFRunLoopAddObserver(instance->_runloop, observer, kCFRunLoopDefaultMode);
    
    
    CFRunLoopSourceContext source0Context = {.version = 0, .info = (__bridge void *)instance, .cancel = NULL, .perform = source0Perform};
    CFRunLoopSourceRef source0 = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &source0Context);
    instance->_source0 = source0;
    CFRunLoopSourceSignal(source0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source0, kCFRunLoopDefaultMode);
    
    CFRelease(observer);
}

static inline void runLoopOberverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    if (activity != kCFRunLoopBeforeWaiting) { return; }
    YHRunLoopTaskManager *instance = (__bridge YHRunLoopTaskManager *)info;
    if (instance.isSuspend) { return; }
    if (instance.tasks.count == 0) { return; }
    
    BOOL result = NO;
    while (result == NO && instance.tasks.count && !instance.isSuspend) {
        YHRunLoopTask *taskUnit = instance.tasks.lastObject;
        instance.currentExecuteTask = taskUnit;
        result = taskUnit.task();
        if (result) {
            [instance.tasks removeObjectAtIndex:0];
        }
    }
    CFRunLoopWakeUp(instance->_runloop);
}

- (void)executeTask:(RunLoopTask)task {
    self.executetTask = [[YHRunLoopTask alloc] initTaskUnit:task forIdentifier:@"false"];
    CFRunLoopSourceSignal(_source0);
    CFRunLoopWakeUp(_runloop);
}

static inline void source0Perform (void *info) {
    YHRunLoopTaskManager *Self = (__bridge YHRunLoopTaskManager *)info;
    while (Self.executetTask && [Self.executetTask.identifier isEqualToString:@"false"]) {
        Self.executetTask.task();
        Self.executetTask.identifier = @"true";
        Self.executetTask = nil;
    }
}

+ (instancetype)defaultManager {
    static YHRunLoopTaskManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [YHRunLoopTaskManager new];
        _sharedInstance.maximumTaskCount = 10;
        _sharedInstance.tasks = [NSMutableArray array];
        _sharedInstance.currentExecuteTask = nil;
        _sharedInstance.suspend = NO;
        [_sharedInstance registerRunloopForObserver:_sharedInstance];
    });
    return _sharedInstance;
}

@end
