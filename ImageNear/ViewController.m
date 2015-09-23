//
//  ViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "ViewController.h"
#import "IMAWebServiceModel.h"
#import "CollectionViewCell.h"
#import "ImageViewController.h"
#import "IMAPhotoObject.h"
#import "IMAPhotoModel.h"
#import "IMAMapObject.h"
#import "IMAConstants.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *photoObjectList;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) NSUInteger updateAttempts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.photoObjectList = [NSMutableArray new];
    self.imageView = [UIImageView new];
    self.updateAttempts = 1;
    [self downloadTheData];
    

    
    
    

    
    
}
- (IBAction)updateLocation:(id)sender {
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    [self.locationManager startUpdatingLocation];
}
-(void)downloadTheData
{
    [[IMAWebServiceModel sharedInstance] fetchMorePhotos:^(NSArray *photoObjects) {
        [self handlePhotoObjects:photoObjects];
    }];
}

-(void)handlePhotoObjects:(NSArray *)photos
{
    if ([photos count] == 0) {
        double currentSearchArea = [IMAWebServiceModel sharedInstance].searchSizeKM;
        currentSearchArea += SearchAreaAccelerationDefault * (self.updateAttempts*self.updateAttempts);
        self.updateAttempts += 1;
        [[IMAWebServiceModel sharedInstance] expandSearchAreaTo:currentSearchArea];
        [[IMAWebServiceModel sharedInstance] fetchMorePhotos:^(NSArray *photoObjects) {
            [self handlePhotoObjects:photoObjects];
        }];
        NSLog(@"The search are is now %.2f", currentSearchArea);
    }
    [self.photoObjectList addObjectsFromArray:photos];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoCollectionView reloadData];
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionView Delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageViewController *imageViewController = [sb instantiateViewControllerWithIdentifier:@"ImageViewController"];
    
    IMAPhotoObject *photoObj = self.photoObjectList[indexPath.row];
    imageViewController.photoObject = photoObj;
    [self.navigationController showViewController:imageViewController sender:self];
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CollectionView Datasources
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    IMAPhotoObject *photoObj = self.photoObjectList[indexPath.row];
    [cell setImageUrl:photoObj.photoFileURL];
    
    return cell;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoObjectList count];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"Need moar rows");
        [[IMAWebServiceModel sharedInstance] fetchMorePhotos:^(NSArray *photoObjects) {
            [self handlePhotoObjects:photoObjects];
        }];
    }
}


#pragma mark - location manager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    
    double lat = newLocation.coordinate.latitude;
    double lon = newLocation.coordinate.longitude;
    
    [[IMAWebServiceModel sharedInstance] setNewLon:lon andLat:lat];
    [[IMAWebServiceModel sharedInstance] resetSearchSize];
    self.updateAttempts = 1;
    [self.photoObjectList removeAllObjects];
    [[IMAWebServiceModel sharedInstance] fetchMorePhotos:^(NSArray *photoObjects) {
        [self handlePhotoObjects:photoObjects];
    }];
    
    NSLog(@"lat: %.6f, lon: %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
}



@end
