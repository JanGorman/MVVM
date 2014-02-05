//
//  JGOCollectionViewModelTests.m
//  MVVM
//
//  Created by Jan Gorman on 2014-01-19.
//  Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveCocoa/ReactiveCocoa/RACSignal+Operations.h>
#import "JGOCollectionViewModel.h"
#import "JGOClient.h"
#import "JGOCollectionModel.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"
#import "OCMArg.h"
#import "OCMockObject.h"
#import "OCMockRecorder.h"

@interface JGOCollectionViewModelTests : XCTestCase

@end

@implementation JGOCollectionViewModelTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFetchCollection {
    JGOClient *client = [[JGOClient alloc] init];
    id mock = [OCMockObject partialMockForObject:client];

    JGOCollectionViewModel *viewModel = [[JGOCollectionViewModel alloc] initWithClient:mock];

    NSDictionary *dictionary = @{
            @"label" : @"Foo",
            @"imageURL" : @"http://cdn.shopify.com/s/files/1/0259/0031/products/Karo_Rigaud-Linocut_Maille_1024x1024.jpg"
    };

    JGOCollectionModel *model = [MTLJSONAdapter modelOfClass:[JGOCollectionModel class]
                                          fromJSONDictionary:dictionary
                                                       error:nil];

    RACSignal *racSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        [subscriber sendNext:@{@"items" : @[model]}];

        return [RACDisposable disposableWithBlock:^{

        }];
    }];
    [[[mock stub] andReturn:racSignal] fetchJSONFromURL:[OCMArg any]];

    [[RACSignal merge:@[[viewModel fetchCollection]]] subscribeCompleted:^{
        NSLog(@"Done");
    }];

    XCTAssert([viewModel numberOfItems] > 0);
}

@end
