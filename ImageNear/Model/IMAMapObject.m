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
        _location = CLLocationCoordinate2DMake(lat, lon);
    }
    return self;
}
-(CLLocationCoordinate2D)antipode
{
    double lat = self.location.latitude*-1;
    double lon = self.location.longitude;
    if (lon < 0) {
        lon += 180.0;
    } else{
        lon -= 180.0;
    }
    return CLLocationCoordinate2DMake(lat, lon);
    
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"Lon %.4f Lat %.4f", self.location.longitude, self.location.latitude];
}

@end
