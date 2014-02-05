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

@interface JGOCollectionViewController ()

@property(strong, nonatomic) JGOCollectionViewModel *viewModel;

@end

@implementation JGOCollectionViewController

#pragma mark Lifecycle

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _viewModel = [[JGOCollectionViewModel alloc] init];

        [[RACSignal merge:@[[_viewModel fetchCollection]]] subscribeCompleted:^{
            [self.collectionView reloadData];
        }];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JGOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JGOCollectionViewCell class])
                                                                            forIndexPath:indexPath];
    cell.imageView.imageWithURL = [self.viewModel imageURLAtIndexPath:indexPath];
    cell.label.text = [self.viewModel labelAtIndexPath:indexPath];

    return cell;
}


@end
