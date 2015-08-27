//
//  IMAPhotoModel.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/26/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMAPhotoModel.h"
#import "IMAPhotoObject.h"

@implementation IMAPhotoModel

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        _photoObjectList = [NSMutableArray new];
        
    }
    return self;
}

+ (IMAPhotoModel*)sharedInstance
{
    static IMAPhotoModel *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[IMAPhotoModel alloc] init];
    });
    return _sharedInstance;
}

-(void)parseJSONDict:(NSDictionary *)jsonDict
{
    if ([jsonDict objectForKey:@"map_location"]) {
        double lon = [jsonDict[@"map_location"][@"lon"] doubleValue];
        double lat = [jsonDict[@"map_location"][@"lat"] doubleValue];
        NSInteger panZoom = [jsonDict[@"map_location"][@"panoramio_zoom"] integerValue];
        self.mapLocation = [[IMAMapObject alloc] initWithLon:lon andLat:lat];
        self.mapLocation.panoramioZoom = panZoom;
        
    }
    if ([jsonDict objectForKey:@"count"]) {
        self.photosAvailable = [jsonDict[@"count"] integerValue];
    }
    if ([jsonDict objectForKey:@"has_more"]) {
        self.hasMorePhotos = [jsonDict[@"has_more"] boolValue];
    }
    if ([jsonDict objectForKey:@"photos"]) {
        for (NSDictionary *aDict in jsonDict[@"photos"]) {
            [self.photoObjectList addObject:[self createPhotoObjectFromDict:aDict]];
        }
    }

}

-(IMAPhotoObject *)createPhotoObjectFromDict:(NSDictionary *)aDict
{
    IMAPhotoObject *photoObject = [IMAPhotoObject new];
    if ([aDict objectForKey:@"place_id"]) {
        photoObject.placeID = aDict[@"place_id"];
    }
    if ([aDict objectForKey:@"owner_name"]) {
        photoObject.ownerName = aDict[@"owner_name"];
    }
    if ([aDict objectForKey:@"owner_id"]) {
        photoObject.ownerID = [aDict[@"owner_id"] integerValue];
    }
    if ([aDict objectForKey:@"longitude"] && [aDict objectForKey:@"latitude"]) {
        double lon = [aDict[@"longitude"] doubleValue];
        double lat = [aDict[@"latitude"] doubleValue];
        photoObject.photoLocation = [[IMAMapObject alloc] initWithLon:lon andLat:lat];
    }
    
    if ([aDict objectForKey:@"photo_title"]) {
        photoObject.photoTitle = aDict[@"photo_title"];
    }
    if ([aDict objectForKey:@"upload_date"]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM yyyy"];
        photoObject.uploadDate = [df dateFromString:aDict[@"upload_date"]];
    }
    if ([aDict objectForKey:@"height"]) {
        photoObject.photoHeight = [aDict[@"height"] integerValue];
    }
    if ([aDict objectForKey:@"width"]) {
        photoObject.photoWidth = [aDict[@"width"] integerValue];
    }
    if ([aDict objectForKey:@"owner_url"]) {
        photoObject.ownerURL = [NSURL URLWithString:aDict[@"owner_url"]];
    }
    if ([aDict objectForKey:@"photo_file_url"]) {
        photoObject.photoFileURL = [NSURL URLWithString:aDict[@"photo_file_url"]];
    }
    if ([aDict objectForKey:@"photo_url"]) {
        photoObject.photoURL = [NSURL URLWithString:aDict[@"photo_url"]];
    }
    if ([aDict objectForKey:@"photo_id"]) {
        photoObject.photoID = [aDict[@"photo_id"] integerValue];
    }
    
    return photoObject;
    
}
@end
