//
//  Buck2ExpensesTableViewController.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Buck2ExpensesTableViewController : UITableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)descriptionChanged:(UITextField *)sender;
- (IBAction)amountChanged:(UITextField *)sender;
- (IBAction)dateChanged:(UITextField *)sender;
- (IBAction)frequencyChanged:(UITextField *)sender;
- (IBAction)unitsChanged:(UITextField *)sender;

- (IBAction)toggleRepeat:(UISwitch *)sender;
- (IBAction)toggleType:(id)sender;

- (IBAction)deleteExpense:(UIButton *)sender;
- (IBAction)addRow:(id)sender;

@end
