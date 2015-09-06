//
//  IMACordHelper.h
//  ImageNear
//
//  Created by Stephen Goodman on 9/6/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMACordHelper : NSObject

+(double)lengthOfDegreesLon:(double)lon atLat:(double)lat;
+(double)lengthOfDegreesLat:(double)lat;

@end
