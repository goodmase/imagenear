//
//  CollectionViewCell.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "CollectionViewCell.h"
#import <Haneke.h>

@interface CollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation CollectionViewCell

-(void)setImageUrl:(NSURL *)url
{
    
    [self.cellImageView hnk_setImageFromURL:url];
}

@end
