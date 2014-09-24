#import <Mantle/Mantle.h>

@interface CCPage : MTLModel <MTLJSONSerializing>
@property (nonatomic) NSInteger perPage;
@property (nonatomic, readonly) NSDictionary *asRequestParams;
@end


@interface CCNumericPage : CCPage
@property (nonatomic) NSInteger page;

+ (CCNumericPage *)firstPage;
@end

@interface CCChronoPage : CCPage
@property (nonatomic) NSInteger sinceId;
@property (nonatomic) NSInteger maxId;
@end


@interface CCPagination : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSString *type;
@end

@interface CCNumericPagination : CCPagination
@property (strong, nonatomic) CCNumericPage *current;
@property (strong, nonatomic) CCNumericPage *next;
@property (strong, nonatomic) CCNumericPage *previous;
@end

@interface CCChronoPagination : CCPagination
@property (strong, nonatomic) CCChronoPage *older;
@property (strong, nonatomic) CCChronoPage *newer;
@end
