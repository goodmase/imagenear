//
//  IMAMapObject.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMAMapObject.h"

@implementation IMAMapObject

-(instancetype)initWithLon:(double)lon andLat:(double)lat
{
    self = [super init];
    if (self) {
        _longitude = lon;
        _latitude = lat;
    }
    return self;
}

@end
