#import "CCRequest+Private.h"
#import "CCRequest.h"

@implementation CCRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.state = CCRequestStateReady;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(af_reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.operation = nil;
}

- (void)setOperation:(AFHTTPRequestOperation *)operation
{
    if (_operation == operation) {
        return;
    }
    [_operation cancel];
    _operation = operation;
}

- (void)cancel
{
    self.operation = nil;
    self.state = CCRequestStateReady;
}

- (void)clearError
{
    self.error = nil;
    self.errorResponseObject = nil;
}

- (void)af_reachabilityDidChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    AFNetworkReachabilityStatus status = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        self.errorResponseObject = @{@"data": NSLocalizedString(@"No internet connection", @"Error message when there is no internet connection")};
        self.state = CCRequestStateLoadedWithError;
    }
}

+ (AFHTTPRequestOperationManager *)requestManager
{
    static dispatch_once_t onceToken;
    static AFHTTPRequestOperationManager *_requestManager;
    dispatch_once(&onceToken, ^{
#warning Please replace baseURLString
        NSString *baseURLString = @"http://localhost:3000";
        _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        NSOperationQueue *operationQueue = _requestManager.operationQueue;
        [_requestManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
        [_requestManager.reachabilityManager startMonitoring];
    });
    return _requestManager;
}

@end
