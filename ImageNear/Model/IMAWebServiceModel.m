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

@interface IMAWebServiceModel()

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isOutOfPhotos;
@property (nonatomic, copy) NSString *nextPageString;
@property (nonatomic, strong) IMAPhotoModel *photoModel;
@property (nonatomic, assign) NSUInteger photoStartNum;

@end

@implementation IMAWebServiceModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _photoModel = [IMAPhotoModel new];
        _photoStepSize = 20;
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

-(NSString *)generateURLString
{
    NSString *mapLocationString = [self genLocPartURLStringWithMapObject:self.photoModel.mapLocation andSize:2.0];
    
    NSString *photoRangeString = [NSString stringWithFormat:@"&from=%lu&to=%lu", (unsigned long)self.photoStartNum, self.photoStartNum+self.photoStepSize];
    
    return [NSString stringWithFormat:@"%@get_panoramas.php?set=public%@%@&size=small&mapfilter=true", WebServiceBaseURL, photoRangeString, mapLocationString];
}
-(NSString *)genLocPartURLStringWithMapObject:(IMAMapObject *)mapObj andSize:(double)size
{
    double minx, maxx, miny, maxy;
    minx = mapObj.longitude - size/2;
    maxx = mapObj.longitude + size/2;
    
    miny = mapObj.latitude - size/2;
    maxy = mapObj.latitude + size/2;
    
    return [NSString stringWithFormat:@"&minx=%.6f&miny=%.6f&maxx=%.6f&maxy=%.6f", minx, miny, maxx, maxy];
}

//makes it so you can load the first page again.
-(void)clearPhotos
{
    self.nextPageString = nil;
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
                
                [self.delegate photoObjectsFetchedByWebservice:photoObjects];
                self.isRefreshing = NO;
                
                
                
            }
            
        }] resume];
    }
    
}




@end
