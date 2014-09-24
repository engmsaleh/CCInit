#import <Mantle/Mantle.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, CCRequestState) {
    CCRequestStateReady,
    CCRequestStateLoading,
    CCRequestStateLoadedFromCache,
    CCRequestStateLoadedSuccessfully,
    CCRequestStateLoadedWithError
};

typedef NS_ENUM(NSInteger, CCRequestMethod) {
    CCRequestGET,
    CCRequestPOST,
    CCRequestHEAD,
    CCRequestPUT,
    CCRequestDELETE,
    CCRequestPATCH
};

@interface CCRequest : NSObject
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) Class responseClass;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSDictionary *errorResponseObject;

- (CCRequestState)state;
- (void)cancel;

@end
