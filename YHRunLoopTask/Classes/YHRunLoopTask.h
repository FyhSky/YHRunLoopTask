//
//  YHRunLoopTask.h
//  YHRunLoopTask
//
//  Created by FengYinghao on 2020/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef BOOL(^RunLoopTask)(void);
@interface YHRunLoopTask : NSObject
@property (nonatomic, copy) RunLoopTask task;
@property (nonatomic, copy) NSString *identifier;
- (instancetype)initTaskUnit:(RunLoopTask)task
               forIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
