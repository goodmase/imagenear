//
//  WebServiceModel.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "IMAWebServiceModel.h"

@implementation IMAWebServiceModel

-(void)downloadJSONFromUrl:(NSURL *)url
{

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                              
                                              NSArray *photoDictList = dataDict[@"photos"];
                                              NSMutableArray *photoList = [NSMutableArray new];
                                              for (NSDictionary *aDict in photoDictList) {
                                                  NSURL *photoUrl = [NSURL URLWithString:aDict[@"photo_url"]];
                                                  [photoList addObject:photoUrl];
                                                                     
                                              }
                                              
                                              
                                          }];
    

    [downloadTask resume];
}

@end
