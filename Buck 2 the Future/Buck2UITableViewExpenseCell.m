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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
