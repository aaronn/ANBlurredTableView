//
//  ANTableViewCell.h
//  ANBlurredTableViewDemo
//
//  Created by Aaron Ng on 3/10/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong) CALayer *topBorder;
@property (strong) CALayer *bottomBorder;
@end
