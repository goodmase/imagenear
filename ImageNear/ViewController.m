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
@property (nonatomic, strong) NSMutableArray *photoObjectList;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) NSUInteger updateAttempts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.photoObjectList = [NSMutableArray new];
    self.updateAttempts = 1;
    
    [self setupRefreshControl];
    //[self downloadTheData];
    
}
-(void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshImages:) forControlEvents:UIControlEventValueChanged];
    [self.photoCollectionView addSubview:self.refreshControl];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupCellSize];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}
-(void)setupCellSize
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    
    CGFloat availableWidthForCells = CGRectGetWidth(self.photoCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (ImageCellsPerRow - 1);
    
    
    CGFloat cellWidth = availableWidthForCells / ImageCellsPerRow;
    
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}
-(void)clearAllImages{
    [[IMAWebServiceModel sharedInstance] clearPhotos];
    [[IMAWebServiceModel sharedInstance] resetSearchSize];
    [self.photoObjectList removeAllObjects];
    [self.photoCollectionView reloadData];
}
-(void)refreshImages:(id)sender
{
    //clear current images
    [self clearAllImages];
    
    //download fresh ones
    [self downloadTheData];
    if (self.refreshControl) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attDict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title attributes:attDict];
        self.refreshControl.attributedTitle = attTitle;
        [self.refreshControl endRefreshing];
    }
    
    
    
    
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
    if ([self.photoObjectList count] > 0) {
        self.photoCollectionView.backgroundView = nil;
        return 1;
    } else{
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.photoCollectionView.bounds.size.width, self.photoCollectionView.bounds.size.height)];
        messageLabel.text = @"No images. Please pull down to refresh.";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
        messageLabel.textColor = [UIColor whiteColor];
        [messageLabel sizeToFit];
        
        self.photoCollectionView.backgroundView = messageLabel;
        
    }
    return 0;
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
    if(y > h + reload_distance && [self.photoObjectList count] > 0) {
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
    
    [self.photoObjectList removeAllObjects];
    [[IMAWebServiceModel sharedInstance] fetchMorePhotos:^(NSArray *photoObjects) {
        
        [self handlePhotoObjects:photoObjects];
    }];
    
    NSLog(@"Cannot find the location.");
}



@end
