//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

@class JGOClient;
@class RACSignal;

@interface JGOCollectionViewModel : NSObject

- (instancetype)initWithClient:(JGOClient *)client;

- (RACSignal *)fetchCollection;

- (NSInteger)numberOfItems;

- (NSURL *)imageURLAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)labelAtIndexPath:(NSIndexPath *)indexPath;

@end