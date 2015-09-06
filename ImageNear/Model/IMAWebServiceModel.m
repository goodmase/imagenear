//
//  WebServiceModel.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMAWebServiceModel.h"
#import "IMAConstants.h"
#import "IMAPhotoModel.h"
#import "IMACordHelper.h"

@interface IMAWebServiceModel()

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isOutOfPhotos;
@property (nonatomic, copy) NSString *nextPageString;
@property (nonatomic, strong) IMAPhotoModel *photoModel;
@property (nonatomic, assign) NSUInteger photoStartNum;
@property (nonatomic, assign, readwrite) double searchSizeKM;

@end

@implementation IMAWebServiceModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _photoModel = [IMAPhotoModel new];
        _photoStepSize = 20;
        _searchSizeKM = 5.0;
    }
    return self;
}

+ (IMAWebServiceModel*)sharedInstance
{
    static IMAWebServiceModel *shared = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shared = [IMAWebServiceModel new];
    });
    return shared;
}
-(void)setNewLon:(double)lon andLat:(double)lat
{
    self.photoModel.isOutOfPhotos = NO;
    self.photoModel.mapLocation = [[IMAMapObject alloc] initWithLon:lon andLat:lat];
}
-(void)expandSearchAreaTo:(double)sizeInKm{
    self.searchSizeKM = sizeInKm;
    self.photoModel.isOutOfPhotos = NO;
}
-(NSString *)generateURLString
{
    
    NSString *mapLocationString = [self genLocPartURLStringWithMapObject:self.photoModel.mapLocation andSize:_searchSizeKM];
    
    NSString *photoRangeString = [NSString stringWithFormat:@"&from=%lu&to=%lu", (unsigned long)self.photoStartNum, self.photoStartNum+self.photoStepSize];
    
    return [NSString stringWithFormat:@"%@get_panoramas.php?set=public%@%@&size=small&mapfilter=true", WebServiceBaseURL, photoRangeString, mapLocationString];
}
//size in km
-(NSString *)genLocPartURLStringWithMapObject:(IMAMapObject *)mapObj andSize:(double)size
{
    double lon_size = [IMACordHelper lonFromKm:size atLat:mapObj.latitude];
    double lat_size = [IMACordHelper latFromKm:size];
    
    
    double minx, maxx, miny, maxy;
    minx = mapObj.longitude - lon_size/2;
    maxx = mapObj.longitude + lon_size/2;
    
    miny = mapObj.latitude - lat_size/2;
    maxy = mapObj.latitude + lat_size/2;
    
    return [NSString stringWithFormat:@"&minx=%.6f&miny=%.6f&maxx=%.6f&maxy=%.6f", minx, miny, maxx, maxy];
}

//makes it so you can load the first page again.
-(void)clearPhotos
{
    self.isOutOfPhotos = NO;
}

-(void)fetchMorePhotos
{
    
    
    if (self.isRefreshing || self.photoModel.isOutOfPhotos) {
        return;
        
    } else{
        self.isRefreshing = YES;
        //or you can make a datatask property and check that
        
        NSString *webserviceURL = [self generateURLString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webserviceURL]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
        
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                
                //TODO handle errors
                
            } else {
                NSArray *photoObjects = [NSArray new];
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                photoObjects = [self.photoModel parseJSONDict:dataDict];
                
                self.photoStartNum += [photoObjects count];
                
                self.isRefreshing = NO;
                [self.delegate photoObjectsFetchedByWebservice:photoObjects];
                
                
                
                
            }
            
        }] resume];
    }
    
}




@end
