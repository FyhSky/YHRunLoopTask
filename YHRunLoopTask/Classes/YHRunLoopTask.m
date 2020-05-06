//
//  YHRunLoopTask.m
//  YHRunLoopTask
//
//  Created by FengYinghao on 2020/5/6.
//

#import "YHRunLoopTask.h"

@implementation YHRunLoopTask
- (instancetype)init {
    if (self = [super init]) {
        _task = nil;
        _identifier = nil;
    }
    return self;
}

- (instancetype)initTaskUnit:(RunLoopTask)task
               forIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _task = task;
        _identifier = [identifier copy];
    }
    return self;
}

- (RunLoopTask)task {
    NSAssert(_task != nil, @"RunLoopTask task can't empty");
    return _task;
}

- (NSString *)identifier {
    NSAssert(_identifier != nil, @"RunLoopTask identifier can't empty");
    return [_identifier copy];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    if ([_identifier isEqualToString:[(YHRunLoopTask *)object identifier]]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return [_identifier hash];
}

@end
