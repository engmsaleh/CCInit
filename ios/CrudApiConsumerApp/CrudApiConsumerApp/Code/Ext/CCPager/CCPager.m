#import "CCRequest+Private.h"
#import "CCPager.h"


@interface CCPager () {
    @protected
    BOOL _hasNext;
}
@property (strong, nonatomic) NSMutableArray *list;
@property (nonatomic) NSInteger listCount;
@property (strong, nonatomic) NSDictionary *meta;
@property (nonatomic) BOOL hasNext;

@end

@implementation CCPager

- (void)clear
{
    self.list = @[].mutableCopy;
    self.listCount = self.list.count;
    self.state = CCRequestStateReady;
}

- (void)removeItemAtIndex:(NSInteger)i apiPath:(NSString *)path
{
    [self.list removeObjectAtIndex:i];
    [self.class.requestManager DELETE:path parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: retry
    }];
}

- (void)refetch
{
}

- (void)fetchMore
{
}

- (void)saveList:(NSArray *)list
{
    switch (self.savingType) {
        case CCPagerOverrideResponse:
            self.list = list.mutableCopy;
            break;
        case CCPagerAppendResponse:
            [self.list addObjectsFromArray:list];
            break;
        case CCPagerPrependResponse:
            [self.list insertObjects:list atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){0, list.count}]];
            break;
        default:
            break;
    }
}

@end


@interface CCNumericPager ()
@property (strong, nonatomic) CCNumericPagination *pagination;

@end

@implementation CCNumericPager

- (id)init
{
    self = [super init];
    if (self) {
        self.hasNext = YES;
    }
    return self;
}

- (void)refetch
{
    [self clear];
    self.pagination = nil;
    [self fetchMore];
}

- (void)fetchMore
{
    [self fetchPage:self.pagination.next];
}

- (void)fetchPage:(CCNumericPage *)page
{
    if (!self.class.requestManager.reachabilityManager.isReachable) {
        if (self.state != CCRequestStateLoadedWithError) {
            self.state = CCRequestStateLoadedWithError;
        }
        return;
    }
    if (self.state == CCRequestStateLoading) {
        return;
    }

    self.state = CCRequestStateLoading;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = self.params ? self.params.mutableCopy : nil;
    [params addEntriesFromDictionary:page ? page.asRequestParams : [CCNumericPage firstPage].asRequestParams];

    self.operation = [self.class.requestManager GET:self.path parameters:params success:^(AFHTTPRequestOperation *operation, id listJSON) {

        [weakSelf clearError];
        weakSelf.meta = listJSON[@"meta"];

        CCNumericPagination *pagination = [MTLJSONAdapter modelOfClass:[CCNumericPagination class]
                                                    fromJSONDictionary:listJSON[@"pagination"]
                                                                 error:NULL];
        weakSelf.pagination = pagination;

        NSArray *list = [MTLJSONAdapter modelsOfClass:weakSelf.responseClass
                                        fromJSONArray:listJSON[@"data"]
                                                error:NULL];
        self.hasNext = pagination.next != nil;
        if (!weakSelf.list) {
            weakSelf.list = @[].mutableCopy;
        }
        [weakSelf saveList:list];
        weakSelf.listCount = weakSelf.list.count;

        weakSelf.state = CCRequestStateLoadedSuccessfully;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.errorResponseObject = operation.responseObject;
        weakSelf.error = error;
        weakSelf.state = CCRequestStateLoadedWithError;
    }];
}

@end




@interface CCReverseChronoPager ()
@property (nonatomic) BOOL force;
@property (strong, nonatomic) CCChronoPagination *pagination;
@property (strong, nonatomic) NSDate *lastCompleteFetchDate;
@end

@implementation CCReverseChronoPager

- (id)init
{
    self = [super init];
    if (self) {
        self.hasNext = YES;
    }
    return self;
}

- (void)refetch
{
    self.hasNext = YES;
    [self clear];
    self.pagination = nil;
    [self fetchMore];
}

- (void)forceFetchMore
{
    self.force = YES;
    [self fetchMore];
}

- (void)fetchPage:(CCChronoPage *)page
{
    if (!self.class.requestManager.reachabilityManager.isReachable) {
        if (self.state != CCRequestStateLoadedWithError) {
            self.state = CCRequestStateLoadedWithError;
        }
        return;
    }
    if (self.state == CCRequestStateLoading) {
        return;
    }

    if (!self.force) {
        if (self.lastCompleteFetchDate != nil && [[NSDate date] timeIntervalSinceDate:self.lastCompleteFetchDate] < 10) {
            return;
        }
    }

    self.state = CCRequestStateLoading;
    self.lastCompleteFetchDate = nil;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = self.params ? self.params.mutableCopy : nil;
    if (page) {
        [params addEntriesFromDictionary:page.asRequestParams];
    }

    self.operation = [self.class.requestManager GET:self.path parameters:params success:^(AFHTTPRequestOperation *operation, id listJSON) {

        [weakSelf clearError];
        weakSelf.meta = listJSON[@"meta"];

        if ([listJSON[@"data"] count] == 0) {
            self.hasNext = NO;
            weakSelf.lastCompleteFetchDate = [NSDate date];
            weakSelf.state = CCRequestStateLoadedSuccessfully;
            return;
        }

        CCChronoPagination *pagination = [MTLJSONAdapter modelOfClass:[CCChronoPagination class]
                                                   fromJSONDictionary:listJSON[@"pagination"]
                                                                error:NULL];
        weakSelf.pagination = pagination;

        NSArray *list = [MTLJSONAdapter modelsOfClass:weakSelf.responseClass
                                        fromJSONArray:listJSON[@"data"]
                                                error:NULL];
        if (!weakSelf.list) {
            weakSelf.list = @[].mutableCopy;
        }
        [weakSelf saveList:list];
        weakSelf.listCount = weakSelf.list.count;

        weakSelf.state = CCRequestStateLoadedSuccessfully;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.errorResponseObject = operation.responseObject;
        weakSelf.error = error;
        if (weakSelf.state != CCRequestStateLoadedWithError) {
            weakSelf.state = CCRequestStateLoadedWithError;
        }
    }];

    [self.operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
}

@end



@implementation CCNewerPager

- (void)fetchMore
{
    [self fetchPage:self.pagination.newer];
}

- (BOOL)hasNext
{
    return YES;
}

@end



@implementation CCOlderPager

- (id)init
{
    self = [super init];
    if (self) {
        self.hasNext = YES;
        self.savingType = CCPagerPrependResponse;
    }
    return self;
}

// For reverse-chronological order, refetching older items means refetching newer items...
- (void)refetch
{
}

- (void)startFromPagination:(CCChronoPagination *)pagination
{
    self.pagination = pagination;
}

- (BOOL)hasNext
{
    return _hasNext && self.pagination.older;
}

- (void)fetchMore
{
    if (self.hasNext) {
        [self fetchPage:self.pagination.older];
    }
}

@end


