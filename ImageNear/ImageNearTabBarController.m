//
//  ImageNearTabBarController.m
//  ImageNear
//
//  Created by Stephen Goodman on 9/23/15.
//  Copyright © 2015 Stephen Goodman. All rights reserved.
//

#import "ImageNearTabBarController.h"
#import "MapViewController.h"
#import "ViewController.h"

@interface ImageNearTabBarController () <UITabBarControllerDelegate>

@end

@implementation ImageNearTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *viewControllerArray = [self viewControllers];
    UINavigationController *navControl = (UINavigationController *)[viewControllerArray objectAtIndex:0];
    ViewController *imageCollectionView = (ViewController *)[[navControl viewControllers] firstObject];
    MapViewController *mapViewController = (MapViewController *)[viewControllerArray objectAtIndex:1];
    
    mapViewController.imageCollectionView = imageCollectionView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
