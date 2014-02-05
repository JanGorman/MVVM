//
//  JGOCollectionViewCell.h
//  MVVM
//
//  Created by Jan Gorman on 2014-01-19.
//  Copyright (c) 2014 Jan Gorman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGOCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *label;

@end
