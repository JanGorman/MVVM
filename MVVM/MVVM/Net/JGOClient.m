//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import "JGOClient.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "RACSubscriber.h"
#import "RACDisposable.h"
#import "RACSequence.h"
#import "NSArray+RACSequenceAdditions.h"
#import "MTLJSONAdapter.h"
#import "JGOCollectionModel.h"

@interface JGOClient ()

@property(strong, nonatomic) NSURLSession *session;

@end

@implementation JGOClient

- (id)init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

#pragma mark Public

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetch from URL %@", url);

    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         if (!error) {
                                                             NSError *serializationError = nil;
                                                             id json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                       options:NSJSONReadingAllowFragments
                                                                                                         error:&serializationError];
                                                             if (!serializationError) {
                                                                 [subscriber sendNext:json];
                                                             } else {
                                                                 [subscriber sendError:serializationError];
                                                             }
                                                         } else {
                                                             [subscriber sendError:error];
                                                         }

                                                         [subscriber sendCompleted];
                                                     }];
        [dataTask resume];

        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (RACSignal *)fetchCollection {
    NSURL *url = [NSURL URLWithString:@"http://arcane-earth-2398.herokuapp.com/collection.json"];

    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        RACSequence *list = [json[@"items"] rac_sequence];

        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[JGOCollectionModel class]
                             fromJSONDictionary:item
                                          error:nil];
        }] array];
    }];
}

@end