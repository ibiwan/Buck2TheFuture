//
//  UITableViewExpenseCell.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/6/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2UITableViewExpenseCell.h"

@implementation Buck2UITableViewExpenseCell

@synthesize description = _description;
@synthesize amount = _amount;
@synthesize date = _date;
@synthesize row = _row;
@synthesize repeatSwitch = _repeatSwitch;
@synthesize type = _type;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)colorFlow {
    switch (self.type) {
        case Income:
            self.flowDirection.text = @"Income";
            self.flowDirection.textColor = incomeGreenFG;
            self.amount.backgroundColor = incomeGreenBG;
            break;
        case Balance:
            self.flowDirection.text = @"Balance";
            self.flowDirection.textColor = balanceBlackFG;
            self.amount.backgroundColor = balanceBlackBG;
            break;
        default: // assume Expense if unknown
            self.flowDirection.text = @"Expense";
            self.flowDirection.textColor = expenseRedFG;
            self.amount.backgroundColor = expenseRedBG;
            break;
    }
    [self setNeedsDisplay];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
