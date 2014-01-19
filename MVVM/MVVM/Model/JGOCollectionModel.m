//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import "JGOCollectionModel.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"


@implementation JGOCollectionModel

#pragma mark Private

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma clang diagnostic pop

#pragma mark - Protocol Conformance

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"label" : @"label",
            @"imageURL" : @"imageURL"
    };
}


@end