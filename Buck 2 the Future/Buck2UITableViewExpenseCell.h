//
//  Buck2UITableViewExpenseCell.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/6/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buck2Expense.h"

#define expenseRedBG   [UIColor colorWithHue:0.0   saturation:0.25 brightness:1.0  alpha:1.0]
#define incomeGreenBG  [UIColor colorWithHue:0.333 saturation:0.25 brightness:0.75 alpha:1.0]
#define balanceBlackBG [UIColor colorWithHue:0.0   saturation:0.0  brightness:0.75 alpha:1.0]

#define expenseRedFG   [UIColor colorWithHue:0.0   saturation:1.0 brightness:0.75  alpha:1.0]
#define incomeGreenFG  [UIColor colorWithHue:0.333 saturation:1.0 brightness:0.75 alpha:1.0]
#define balanceBlackFG [UIColor blackColor]

@interface Buck2UITableViewExpenseCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *description;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UILabel *flowDirection;

//@property (nonatomic) BOOL isExpense;
@property (nonatomic) eventType type;
@property (nonatomic) NSUInteger row;

@property (strong, nonatomic) IBOutlet UISwitch *repeatSwitch;

- (void)colorFlow;
- (BOOL) textFieldShouldReturn:(UITextField *) textField;

@end
