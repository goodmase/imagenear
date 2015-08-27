//
//  ViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/3/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "ViewController.h"
#import "WebServiceModel.h"
#import "CollectionViewCell.h"
#import "ImageViewController.h"
#import "IMAPhotoObject.h"
#import "IMAPhotoModel.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *photoList;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.photoList = [NSMutableArray new];
    self.imageView = [UIImageView new];
    [self downloadTheData];

    
    
}
-(void)downloadTheData
{
    //WebServiceModel *model = [WebServiceModel new];
    //lat (y) 36.161162 long (x) -86.960907
    //lat (y) 36.006895 long (x) -86.727448
    
    //NSURL *url = [[NSURL alloc] initWithString:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=20&minx=-180&miny=-90&maxx=180&maxy=90&size=medium&mapfilter=true"];
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=20&minx=-86.960907&miny=36.006895&maxx=-86.727448&maxy=36.161162&size=small&mapfilter=true"];
    //[model downloadJSONFromUrl: url];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                              
                                              IMAPhotoModel *photoModel = [IMAPhotoModel sharedInstance];
                                              [photoModel parseJSONDict:dataDict];
                                              
                                              
                                              self.photoList = dataDict[@"photos"];
  
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.photoCollectionView reloadData];
                                              });
                                              
                                              
                                              
                                          }];
    
    
    [downloadTask resume];
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
    
    NSDictionary *aDict = [self.photoList objectAtIndex:indexPath.row];
    NSString *photo_id = aDict[@"photo_id"];
    
    NSURL *photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.panoramio.com/photos/large/%@.jpg", photo_id]];
    
    imageViewController.fullScreenURL = photoUrl;
    
    
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
    
    NSDictionary *aDict = [self.photoList objectAtIndex:indexPath.row];
    NSURL *photoUrl = [NSURL URLWithString:aDict[@"photo_file_url"]];
    
    [cell setImageUrl:photoUrl];
    
    return cell;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoList count];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0f;
}




@end
