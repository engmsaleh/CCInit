#import "UITableView+CC.h"

@implementation UITableView (CC)

- (void)registerNibName:(NSString *)nibName
{
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
}

- (void)registerNibNames:(NSArray *)nibNames
{
    for (NSString *name in nibNames) {
        [self registerNibName:name];
    }
}

- (void)registerDefaultIndexTableViewCells
{
    [self registerNibNames:@[
                             ]];
}

@end
