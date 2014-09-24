#import "CCRequest+Private.h"
#import "CCOneResourceRequest.h"


@interface CCOneResourceRequest ()
@property (strong, nonatomic) id responseObject;
@property (strong, nonatomic) id parsedResponseObject;

@end

@implementation CCOneResourceRequest

- (id)initWithPath:(NSString *)path
            params:(NSDictionary *)params
     responseClass:(Class)responseClass
{
    self = [self init];
    if (self) {
        self.path = path;
        self.params = params;
        self.responseClass = responseClass;
    }
    return self;
}

- (void)setResponseObject:(id)responseObject
{
    _responseObject = responseObject;
    NSLog(@"response object: %@", responseObject);
    if (self.error) {
        self.parsedResponseObject = nil;
        return;
    }

    if (responseObject) {
        if (self.responseClass) {
            self.parsedResponseObject = [MTLJSONAdapter modelOfClass:self.responseClass fromJSONDictionary:responseObject[@"data"] error:NULL];
        }
    } else {
        self.parsedResponseObject = nil;
    }
}

- (void)performWithMethod:(CCRequestMethod)method
{
    self.state = CCRequestStateLoading;
    __weak typeof(self) weakSelf = self;
    switch (method) {
        case CCRequestGET: {
            self.operation = [self.class.requestManager GET:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [weakSelf clearError];

                weakSelf.responseObject = responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        case CCRequestPOST: {
            self.operation = [self.class.requestManager POST:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [weakSelf clearError];

                weakSelf.responseObject = responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        case CCRequestHEAD: {
            self.operation = [self.class.requestManager HEAD:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation) {

                [weakSelf clearError];

                weakSelf.responseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        case CCRequestPUT: {
            self.operation = [self.class.requestManager PUT:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [weakSelf clearError];

                weakSelf.responseObject = responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        case CCRequestDELETE: {
            self.operation = [self.class.requestManager DELETE:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [weakSelf clearError];

                weakSelf.responseObject = responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        case CCRequestPATCH: {
            self.operation = [self.class.requestManager PATCH:self.path parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [weakSelf clearError];

                weakSelf.responseObject = responseObject;
                weakSelf.state = CCRequestStateLoadedSuccessfully;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                weakSelf.error = error;
                weakSelf.errorResponseObject = operation.responseObject;
                weakSelf.state = CCRequestStateLoadedWithError;
            }];
            break;
        }
        default:
            break;
    }
}

@end
