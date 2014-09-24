#import "UIView+CC.h"

@implementation UIView (CC)

+ (id)viewFromNibName:(NSString *)name
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:name
                                                  owner:self
                                                options:nil] firstObject];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
