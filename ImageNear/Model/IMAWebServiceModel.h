//
//  IMAWebServiceModel.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IMAMapObject;
@interface IMAWebServiceModel : NSObject

+(IMAWebServiceModel*)sharedInstance;
-(IMAMapObject *)getCurrentMapLocation;
-(void)setNewLon:(double)lon andLat:(double)lat;
-(void)fetchMorePhotos:(void(^)(NSArray *photoObjects))callBack;
-(void)downloadPhotoWithURL:(NSURL *)photoURL completionHandler:(void(^)(UIImage *image, NSError *error))callBack;
-(void)clearPhotos;
-(void)resetSearchSize;
-(void)expandSearchAreaTo:(double)sizeInKm;

@property (nonatomic, assign) NSUInteger photoStepSize;
@property (nonatomic, assign, readonly) double searchSizeKM;

@end
