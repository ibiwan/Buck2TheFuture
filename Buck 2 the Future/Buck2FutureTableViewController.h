//
//  Buck2FutureTableViewController.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buck2CrystalBall.h"

@interface Buck2FutureTableViewController : UITableViewController

@property (weak, nonatomic) NSArray *budgetEvents;
@property (strong, nonatomic) NSNumber *yellowLimit;
@property (strong, nonatomic) NSNumber *redLimit;

@end
