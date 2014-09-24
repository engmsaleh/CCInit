#import "UIScrollView+CC.h"

@implementation UIScrollView (CC)

- (BOOL)isNearTopEnd
{
    return self.contentOffset.y < 10;
}

- (BOOL)isNearBottomEnd
{
    return self.contentOffset.y + self.frame.size.height + 150 > self.contentSize.height;
}

- (BOOL)isNearRightEnd
{
    return self.contentOffset.x + self.frame.size.width > self.contentSize.width;
}

@end
