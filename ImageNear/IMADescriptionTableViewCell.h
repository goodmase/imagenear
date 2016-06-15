//
//  IMADescriptionTableViewCell.h
//  ImageNear
//
//  Created by Stephen Goodman on 9/30/15.
//  Copyright © 2015 Stephen Goodman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMADescriptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
