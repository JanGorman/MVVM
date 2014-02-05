//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa/RACSignal.h>
#import "JGOCollectionViewModel.h"
#import "JGOCollectionModel.h"
#import "JGOClient.h"
#import "RACSignal+Operations.h"

@interface JGOCollectionViewModel ()

@property(strong, nonatomic) NSMutableArray *collectionModels;
@property(strong, nonatomic) JGOClient *client;

@end

@implementation JGOCollectionViewModel

- (instancetype)init {
    return [self initWithClient:[[JGOClient alloc] init]];
}

- (instancetype)initWithClient:(JGOClient *)client {
    self = [super init];
    if (self) {
        _collectionModels = [NSMutableArray array];
        _client = client;
    }

    return self;
}

#pragma mark Public

- (RACSignal *)fetchCollection {
    return [[self.client fetchCollection] doNext:^(NSArray *models) {
        [self.collectionModels addObjectsFromArray:models];
    }];
}

- (NSInteger)numberOfItems {
    return [self.collectionModels count];
}

- (NSURL *)imageURLAtIndexPath:(NSIndexPath *)indexPath {
    JGOCollectionModel *model = self.collectionModels[indexPath.row];
    return model.imageURL;
}

- (NSString *)labelAtIndexPath:(NSIndexPath *)indexPath {
    JGOCollectionModel *model = self.collectionModels[indexPath.row];
    return model.label;
}

@end