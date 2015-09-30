//
//  ImageViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 8/5/15.
//  Copyright (c) 2015 Stephen Goodman. All rights reserved.
//

#import "ImageViewController.h"
#import "IMAPhotoObject.h"
#import "IMAWebServiceModel.h"

@interface ImageViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *fullScreenImageView;
@property (weak, nonatomic) IBOutlet UITextView *textViewProperties;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)setupTextView{
    
    NSString *textViewString = [NSString stringWithFormat:@"%@\n"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    
    self.navigationItem.title = self.photoObject.photoTitle;
    
    [[IMAWebServiceModel sharedInstance] downloadPhotoWithURL:self.photoObject.largePhotoFileURL completionHandler:^(UIImage *image, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fullScreenImageView.image = image;
            });
        }
    }];
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
