//
//  YHRunLoopTaskManager.h
//  YHRunLoopTask
//
//  Created by FengYinghao on 2020/5/6.
//

#import <Foundation/Foundation.h>
#import "YHRunLoopTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHRunLoopTaskManager : NSObject
@property (nonatomic, assign) NSUInteger maximumTaskCount;

+ (instancetype)defaultManager;

- (void)addTask:(YHRunLoopTask *)taskUnit;
- (void)removeTask:(YHRunLoopTask *)taskUnit;
- (void)removeTaskForIdentifier:(NSString *)identifier;

- (void)removeAllTaskUnit;
- (void)suspend;
- (void)resume;

- (void)addTask:(RunLoopTask)task forIdentifier:(NSString *)identifier;
- (void)executeTask:(RunLoopTask)task;
@end

NS_ASSUME_NONNULL_END
