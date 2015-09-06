//
//  IMACordHelper.m
//  ImageNear
//
//  Created by Stephen Goodman on 9/6/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMACordHelper.h"

@implementation IMACordHelper

//calculate the length of degree lon at a certain lat in km
+(double)kmFromDegreesLon:(double)lon atLat:(double)lat
{
    return cos(lat*M_PI/180)*111.325*lon;
}
//calculate the length of a degree lat in km
+(double)kmFromDegreesLat:(double)lat
{
    return lat*111.325;
}



@end
