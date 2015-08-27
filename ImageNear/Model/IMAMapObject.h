//
//  IMAMapObject.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAMapObject : NSObject

-(instancetype)initWithLon:(double)lon andLat:(double)lat;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSInteger panoramioZoom;

@end
