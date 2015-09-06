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

-(double)antipodeLatitude
{
    return self.latitude*-1;
}
-(double)antipodeLongitude
{
    if (self.longitude < 0) {
        return self.longitude + 180.0;
    }
    return self.longitude-180.0;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"Cord: Lat %.4f, Lon %.4f Antipode: Lat %.4f, Lon %.4f", self.latitude, self.longitude, self.antipodeLatitude, self.antipodeLongitude];
}

@end
