#import <UIKit/UIKit.h>

@interface UIScrollView (CC)
@property (nonatomic, readonly) BOOL isNearTopEnd;
@property (nonatomic, readonly) BOOL isNearBottomEnd;
@property (nonatomic, readonly) BOOL isNearRightEnd;

@end
