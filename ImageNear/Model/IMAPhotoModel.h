//
//  IMAPhotoModel.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAMapObject.h"

@interface IMAPhotoModel : NSObject

@property (nonatomic, strong) NSMutableArray *photoObjectList;
@property (nonatomic, assign) NSInteger photosAvailable;
@property (nonatomic, strong) IMAMapObject *mapLocation;
@property (nonatomic, assign) BOOL hasMorePhotos;

+(IMAPhotoModel*)sharedInstance;
-(void)parseJSONDict:(NSDictionary *)jsonDict;

@end
