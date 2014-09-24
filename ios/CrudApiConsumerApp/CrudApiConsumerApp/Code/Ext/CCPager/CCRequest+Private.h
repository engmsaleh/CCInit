#import "CCRequest.h"

@interface CCRequest ()

@property (nonatomic) CCRequestState state;
@property (strong, nonatomic) AFHTTPRequestOperation *operation;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSDictionary *errorResponseObject;

- (void)clearError;

+ (AFHTTPRequestOperationManager *)requestManager;

@end
