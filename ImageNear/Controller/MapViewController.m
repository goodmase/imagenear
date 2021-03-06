//
//  MapViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 9/23/15.
//  Copyright © 2015 Stephen Goodman. All rights reserved.
//

#import "MapViewController.h"
#import "IMAMapObject.h"
#import "IMAWebServiceModel.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *currentLocation;
@property (nonatomic, strong) MKPointAnnotation *centerLocation;
@property (weak, nonatomic) IBOutlet UIImageView *centerPinView;
@property (weak, nonatomic) IBOutlet UIButton *updateLocationButtonProperties;
@property (weak, nonatomic) IBOutlet UIButton *antipodeButtonProperties;

@property (nonatomic, assign) BOOL isLocationUpdated;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.centerPinView.hidden = YES;
    self.updateLocationButtonProperties.hidden = YES;
    [self setupButtonShadows];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.centerPinView.hidden = YES;
    self.updateLocationButtonProperties.hidden = YES;
    //remove our annotation
    [self.mapView removeAnnotation:self.currentLocation];
    [self.mapView removeAnnotation:self.centerLocation];
    self.currentLocation = nil;
    self.centerLocation = nil;
    if (self.isLocationUpdated) {
        [self.imageCollectionView refreshImages:nil];
        self.isLocationUpdated = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateRegion];
    [self addCurrentLocationAnnotation];
}
-(void)setupButtonShadows
{
    CALayer *updateLocationLayer = [self.updateLocationButtonProperties layer];
    updateLocationLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    updateLocationLayer.shadowOpacity = 0.8f;
    updateLocationLayer.shadowRadius = 1.0f;
    updateLocationLayer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    
    CALayer *antipodeLocationLayer = [self.antipodeButtonProperties layer];
    antipodeLocationLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    antipodeLocationLayer.shadowOpacity = 0.8f;
    antipodeLocationLayer.shadowRadius = 1.0f;
    antipodeLocationLayer.shadowOffset = CGSizeMake(1.0f, 1.0f);
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)updateRegion
{
    IMAMapObject *currentLocation = [[IMAWebServiceModel sharedInstance] getCurrentMapLocation];
    
    CLLocationCoordinate2D center = currentLocation.location;
    CLLocationDistance distanceInM = [IMAWebServiceModel sharedInstance].searchSizeKM*1000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, distanceInM, distanceInM);
    [self.mapView setRegion:region animated:YES];
    
    
}

-(void)addCurrentLocationAnnotation
{
    IMAMapObject *currentLocation = [[IMAWebServiceModel sharedInstance] getCurrentMapLocation];
    CLLocationCoordinate2D center = currentLocation.location;
    
    self.currentLocation = [[MKPointAnnotation alloc] init];
    self.currentLocation.coordinate = center;
    self.currentLocation.title = @"My location";

    [self.mapView addAnnotation:self.currentLocation];
}
-(void)updateCenterLocation:(CLLocationCoordinate2D)center
{
    if (!self.centerLocation) {
        self.centerLocation = [[MKPointAnnotation alloc] init];
        
        [self.mapView addAnnotation:self.centerLocation];
    }
    self.centerLocation.title = [NSString stringWithFormat:@"%.2f°, %.2f°", center.longitude, center.latitude];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.centerLocation.coordinate = center;
        [self.mapView setCenterCoordinate:center animated:YES];
    });
    
}
- (IBAction)antipodeButtonPressed:(id)sender {
    CLLocationCoordinate2D center = self.mapView.centerCoordinate;
    //[self.mapView removeAnnotation:self.currentLocation];
    //[self.mapView removeAnnotation:self.centerLocation];

    
    IMAMapObject *mapObject = [[IMAMapObject alloc] initWithLon:center.longitude andLat:center.latitude];
    [self updateCenterLocation:mapObject.antipode];
}
- (IBAction)updateLocationButtonPressed:(id)sender {
    
    CLLocationCoordinate2D center = self.mapView.centerCoordinate;
    //[self.mapView removeAnnotation:self.currentLocation];
    //[self.mapView removeAnnotation:self.centerLocation];
    [self updateCenterLocation:center];
    
    [[IMAWebServiceModel sharedInstance] setNewLon:center.longitude andLat:center.latitude];
    [[IMAWebServiceModel sharedInstance] resetSearchSize];
    
    self.isLocationUpdated = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if (self.centerPinView.hidden) {
        self.centerPinView.hidden = NO;
        self.updateLocationButtonProperties.hidden = NO;
    
    }
    
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{

}

/*
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"point"];
    return pinView;
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
