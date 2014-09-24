#import "CCRequest.h"

@interface CCOneResourceRequest : CCRequest

@property (nonatomic, readonly) id responseObject;
@property (nonatomic, readonly) id parsedResponseObject;

- (id)initWithPath:(NSString *)path
            params:(NSDictionary *)params
     responseClass:(Class)responseClass;

- (void)performWithMethod:(CCRequestMethod)method;

@end
