//
// Created by Jan Gorman on 2014-01-19.
// Copyright (c) 2014 Jan Gorman. All rights reserved.
//

@import Foundation;

@class RACSignal;

@interface JGOClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;

- (RACSignal *)fetchCollection;

@end