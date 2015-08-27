//
//  ImageViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/5/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "ImageViewController.h"
#import <Haneke.h>

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(instancetype)init{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:self.fullScreenURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       if (!error) {
                                                           UIImage *downloadedImage = [UIImage imageWithData:
                                                                                       [NSData dataWithContentsOfURL:location]];
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               self.fullScreenImageView.image = downloadedImage;
                                                               
                                                           });
                                                           
                                                           
                                                       }
                                                       
                                                   }];
    
    
    [downloadPhotoTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
