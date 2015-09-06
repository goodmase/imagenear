//
//  IMAWebServiceModel.h
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMAWebServiceDelegate <NSObject>
- (void)photoObjectsFetchedByWebservice:(NSArray *)photos;
@end

@interface IMAWebServiceModel : NSObject

+(IMAWebServiceModel*)sharedInstance;
-(void)fetchMorePhotos;
-(void)clearPhotos;

@property (nonatomic, assign) id<IMAWebServiceDelegate> delegate;
@property (nonatomic, assign) NSUInteger photoStepSize;

@end
