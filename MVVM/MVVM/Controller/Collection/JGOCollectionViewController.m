//
//  JGOCollectionViewController.m
//  MVVM
//
//  Created by Jan Gorman on 2014-01-19.
//  Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa/RACSignal.h>
#import "JGOCollectionViewController.h"
#import "JGOCollectionViewCell.h"
#import "JGOCollectionViewModel.h"
#import "RACSignal+Operations.h"
#import "UIImageView+AFNetworking.h"
#import "UIScrollView+SVInfiniteScrolling.h"

static const int kTriggerOffset = 10;

@interface JGOCollectionViewController ()

@property(strong, nonatomic) JGOCollectionViewModel *viewModel;

@property(assign, nonatomic) NSUInteger currentPage;
@property(strong, nonatomic) NSMutableSet *loadPoints;

@end

@implementation JGOCollectionViewController

#pragma mark Lifecycle

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _viewModel = [[JGOCollectionViewModel alloc] init];
        _loadPoints = [NSMutableSet set];

        [[RACSignal merge:@[[_viewModel fetchCollection]]] subscribeCompleted:^{
            [self.collectionView reloadData];
        }];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self addInfiniteScrolling];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self triggerInfiniteScrolling:indexPath];

    JGOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JGOCollectionViewCell class])
                                                                            forIndexPath:indexPath];
    cell.imageView.imageWithURL = [self.viewModel imageURLAtIndexPath:indexPath];
    cell.label.text = [self.viewModel labelAtIndexPath:indexPath];

    return cell;
}

#pragma mark - Private

- (void)addInfiniteScrolling {
    __weak JGOCollectionViewController *weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;

        [[RACSignal merge:@[[weakSelf.viewModel fetchCollection]]] subscribeCompleted:^{
            [weakSelf.collectionView reloadData];
        }];
    }];
}

- (void)triggerInfiniteScrolling:(NSIndexPath *)indexPath {
    if (indexPath.row % kTriggerOffset == 0 && ![self.loadPoints containsObject:@(indexPath.row)]) {
        [self.loadPoints addObject:@(indexPath.row)];
        [self.collectionView triggerInfiniteScrolling];
    }
}

@end
