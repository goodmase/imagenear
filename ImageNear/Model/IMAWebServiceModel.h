//
//  IMAWebServiceModel.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IMAWebServiceModel : NSObject

+(IMAWebServiceModel*)sharedInstance;
-(void)setNewLon:(double)lon andLat:(double)lat;
-(void)fetchMorePhotos:(void(^)(NSArray *photoObjects))callBack;
-(void)clearPhotos;
-(void)resetSearchSize;
-(void)expandSearchAreaTo:(double)sizeInKm;

@property (nonatomic, assign) NSUInteger photoStepSize;
@property (nonatomic, assign, readonly) double searchSizeKM;

@end
