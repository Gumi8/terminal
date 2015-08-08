//
//  PhotoCollectionViewCell.m
//  Terminal
//
//  Created by 123 on 18/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = YES;
}

@end
