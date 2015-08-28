//
//  IMAPhotoObject.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMAPhotoObject.h"

#define kLargePhotoBaseURL @"http://static.panoramio.com/photos/large/"

@interface IMAPhotoObject()
@property (nonatomic, readwrite) NSURL *largePhotoFileURL;
@end

@implementation IMAPhotoObject

-(void)setPhotoID:(NSInteger)photoID
{
    _photoID = photoID;
    _largePhotoFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%li.jpg", kLargePhotoBaseURL, (long)photoID]];
    
}

@end
