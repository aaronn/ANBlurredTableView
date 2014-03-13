//
//  ANViewController.h
//  ANBlurredTableViewDemo
//
//  Created by Aaron Ng on 3/10/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANBlurredTableView.h"

@interface ANViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (assign) IBOutlet ANBlurredTableView *tableView;

@end
