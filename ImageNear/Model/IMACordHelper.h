//
//  IMACordHelper.h
//  ImageNear
//
//  Created by Stephen Goodman on 9/6/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMACordHelper : NSObject

+(double)kmFromDegreesLon:(double)lon atLat:(double)lat;
+(double)kmFromDegreesLat:(double)lat;
+(double)lonFromKm:(double)km atLat:(double)lat;
+(double)latFromKm:(double)km;

@end
