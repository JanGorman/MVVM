//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

@import Foundation;

#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface JGOCollectionModel : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong, readonly) NSString *label;
@property(nonatomic, strong, readonly) NSURL *imageURL;

@end