#import "CCPage.h"
#import "CCRequest.h"

typedef NS_ENUM(NSInteger, CCPagerResponseSavingType) {
    CCPagerAppendResponse,
    CCPagerPrependResponse,
    CCPagerOverrideResponse
};

@interface CCPager : CCRequest
@property (nonatomic) CCPagerResponseSavingType savingType;
@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, readonly) NSInteger listCount;
@property (nonatomic, readonly) NSDictionary *meta;
@property (nonatomic, readonly) BOOL hasNext;

- (void)removeItemAtIndex:(NSInteger)i apiPath:(NSString *)path;
- (void)clear;
- (void)refetch;
- (void)fetchMore;
@end


@interface CCNumericPager : CCPager
@property (nonatomic, readonly) CCNumericPagination *pagination;

- (void)fetchPage:(CCNumericPage *)page;
@end


@interface CCReverseChronoPager : CCPager
@property (nonatomic, readonly) CCChronoPagination *pagination;

- (void)forceFetchMore; // after creating new messages
@end

@interface CCNewerPager : CCReverseChronoPager
@end

@interface CCOlderPager : CCReverseChronoPager
- (void)startFromPagination:(CCChronoPagination *)pagination;
@end
