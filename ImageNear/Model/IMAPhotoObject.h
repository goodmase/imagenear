//
//  IMAPhotoObject.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAMapObject.h"

@interface IMAPhotoObject : NSObject

@property (nonatomic, copy) NSString *placeID;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, strong) IMAMapObject *photoLocation;
@property (nonatomic, assign) NSInteger ownerID;
@property (nonatomic, copy) NSString *photoTitle;
@property (nonatomic, strong) NSDate *uploadDate;
@property (nonatomic, assign) NSInteger photoHeight;
@property (nonatomic, assign) NSInteger photoWidth;
@property (nonatomic, strong) NSURL *ownerURL;
@property (nonatomic, strong) NSURL *photoFileURL;
@property (nonatomic, readonly) NSURL *largePhotoFileURL;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, assign) NSInteger photoID;


@end
