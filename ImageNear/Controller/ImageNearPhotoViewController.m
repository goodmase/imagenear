//
//  ImageNearPhotoViewController.m
//  ImageNear
//
//  Created by Stephen Goodman on 9/30/15.
//  Copyright © 2015 Stephen Goodman. All rights reserved.
//

#import "ImageNearPhotoViewController.h"
#import "IMADescriptionTableViewCell.h"
#import "IMAPhotoTableViewCell.h"
#import "IMAPhotoObject.h"
#import "IMAWebServiceModel.h"

@interface ImageNearPhotoViewController ()

@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic, assign) CGFloat imageCellHeight;
@property (nonatomic, assign) CGFloat textCellHeight;

@end

@implementation ImageNearPhotoViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        _imageCellHeight = 300.0f;
        _textCellHeight = 200.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMAPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IMADescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"descriptionCell"];
    
    self.navigationItem.title = self.photoObject.photoTitle;
    
    [[IMAWebServiceModel sharedInstance] downloadPhotoWithURL:self.photoObject.largePhotoFileURL completionHandler:^(UIImage *image, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mainImage = image;
                CGFloat height = image.size.height;
                CGFloat width = image.size.width;
                CGFloat cellWidth = CGRectGetWidth(self.view.bounds)-32;
                if (width > cellWidth) {
                    
                    CGFloat ratio = height/width;
                    height = cellWidth * ratio;
                    
                }
                
                self.imageCellHeight = height;
                
                
                
                [self.tableView reloadData];
            });
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IMAPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        cell.imageView.image = self.mainImage;


        return cell;
    } else{
        IMADescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
        cell.photoTitleLabel.text = self.photoObject.photoTitle;
        cell.usernameLabel.text = self.photoObject.ownerName;
        cell.locationLabel.text = [NSString stringWithFormat:@"%@", self.photoObject.photoLocation];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return self.imageCellHeight;
    } else{
        
        return self.textCellHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return self.imageCellHeight;
    } else{
        
        return self.textCellHeight;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
