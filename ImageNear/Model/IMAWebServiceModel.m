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
@property (nonatomic, strong) NSDictionary *coolPlaces;
@property (nonatomic, assign, readwrite) double searchSizeKM;

@end

@implementation IMAWebServiceModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _photoModel = [IMAPhotoModel new];
        _photoStepSize = 20;
        _searchSizeKM = SearchAreaDefault;
        _coolPlaces = [self coolPlacesDict];
    }
    return self;
}
-(NSDictionary *)coolPlacesDict
{
    IMAMapObject *mapObjFiji = [[IMAMapObject alloc] initWithLon:177.958536 andLat:-17.907888];
    IMAMapObject *mapObjChristchurchNZ = [[IMAMapObject alloc] initWithLon:172.636225 andLat:-43.532054];
    IMAMapObject *mapObjTanglerMorocco = [[IMAMapObject alloc] initWithLon:-5.796385 andLat:35.736544];
    IMAMapObject *mapObjHawaii = [[IMAMapObject alloc] initWithLon:-155.468628 andLat:19.568469];
    
    return @{@"Fiji":mapObjFiji,
             @"Christchurch, New Zealand":mapObjChristchurchNZ,
             @"Tangler, Morocco":mapObjTanglerMorocco,
             @"Hawaii": mapObjHawaii};
}
-(void)resetSearchSize
{
    self.searchSizeKM = SearchAreaDefault;
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
-(IMAMapObject *)getCurrentMapLocation
{
    return self.photoModel.mapLocation;
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
    
    NSString *mapLocationString = [self genLocPartURLStringWithMapObject:self.photoModel.mapLocation andSize:_searchSizeKM isAntipod:NO];
    
    NSString *photoRangeString = [NSString stringWithFormat:@"&from=%lu&to=%lu", (unsigned long)self.photoStartNum, self.photoStartNum+self.photoStepSize];
    
    return [NSString stringWithFormat:@"%@get_panoramas.php?set=public%@%@&size=small&mapfilter=true", WebServiceBaseURL, photoRangeString, mapLocationString];
}
//size in km
-(NSString *)genLocPartURLStringWithMapObject:(IMAMapObject *)mapObj andSize:(double)size isAntipod:(BOOL)antipode
{
    double lon, lat;
    if (antipode) {
        lon = mapObj.antipodeLongitude;
        lat = mapObj.antipodeLatitude;
    } else{
        lon = mapObj.longitude;
        lat = mapObj.latitude;
    }
    double lon_size = [IMACordHelper lonFromKm:size atLat:lat];
    double lat_size = [IMACordHelper latFromKm:size];
    
    
    double minx, maxx, miny, maxy;
    minx = lon - lon_size/2;
    maxx = lon + lon_size/2;
    
    miny = lat - lat_size/2;
    maxy = lat + lat_size/2;
    
    return [NSString stringWithFormat:@"&minx=%.6f&miny=%.6f&maxx=%.6f&maxy=%.6f", minx, miny, maxx, maxy];
}


//makes it so you can load the first page again.
-(void)clearPhotos
{
    self.isOutOfPhotos = NO;
}

-(void)fetchMorePhotos:(void(^)(NSArray *photoObjects))callBack
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
                self.isRefreshing = NO;
                
            } else {
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSArray *photoObjects = [self.photoModel parseJSONDict:dataDict];
                
                self.photoStartNum += [photoObjects count];
                
                self.isRefreshing = NO;
                callBack(photoObjects);
                
                
                
                
            }
            
        }] resume];
    }
    
}

-(void)downloadPhotoWithURL:(NSURL *)photoURL completionHandler:(void(^)(UIImage *image, NSError *error))callBack

{
    [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:photoURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *downloadedImage = [UIImage imageWithData:data];
            callBack(downloadedImage, error);
        } else{
            callBack(nil, error);
        }
    }] resume];
    
}




@end
