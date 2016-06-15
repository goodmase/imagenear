//
//  IMAMapObject.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface IMAMapObject : NSObject

-(instancetype)initWithLon:(double)lon andLat:(double)lat;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) NSInteger panoramioZoom;

-(CLLocationCoordinate2D)antipode;

@end
