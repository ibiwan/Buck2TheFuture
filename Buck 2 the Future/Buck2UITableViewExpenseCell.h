//
//  Buck2UITableViewExpenseCell.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/6/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Buck2UITableViewExpenseCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *description;

@property (strong, nonatomic) IBOutlet UITextField *amount;

@property (strong, nonatomic) IBOutlet UITextField *date;

@property (nonatomic) NSUInteger row;

@property (strong, nonatomic) IBOutlet UISwitch *repeatSwitch;

- (BOOL) textFieldShouldReturn:(UITextField *) textField;

@end
