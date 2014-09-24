#import "CCPage.h"

@implementation CCPage

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

@end

@implementation CCNumericPage

- (NSDictionary *)asRequestParams
{
    return @{
             @"page": @(self.page),
             @"per_page": @(self.perPage)
             };
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (CCNumericPage *)firstPage
{
    CCNumericPage *page = [[CCNumericPage alloc] init];
    page.page = 1;
    page.perPage = 20;
    return page;
}

@end


@implementation CCChronoPage

- (NSDictionary *)asRequestParams
{
    NSMutableDictionary *dict = @{
                                  @"per_page": @(self.perPage)
                                  }.mutableCopy;
    if (self.sinceId >= 0) {
        dict[@"since_id"] = @(self.sinceId);
    }
    if (self.maxId > 0) {
        dict[@"max_id"] = @(self.maxId);
    }
    return dict;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

@end


@implementation CCPagination

#pragma mark - MTLJSONSerializing

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if ([JSONDictionary[@"type"] hasSuffix:@"chronological"]) {
        return [CCChronoPagination class];
    }
    return [CCNumericPagination class];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

@end


@implementation CCNumericPagination

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)nextJSONTransformer
{
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CCNumericPage class]];
}

+ (NSValueTransformer *)previousJSONTransformer
{
    return [self nextJSONTransformer];
}

+ (NSValueTransformer *)currentJSONTransformer
{
    return [self nextJSONTransformer];
}

@end

@implementation CCChronoPagination

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)olderJSONTransformer
{
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CCChronoPage class]];
}

+ (NSValueTransformer *)newerJSONTransformer
{
    return [self olderJSONTransformer];
}

@end
