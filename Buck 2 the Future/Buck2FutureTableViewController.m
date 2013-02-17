//
//  Buck2FutureTableViewController.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2FutureTableViewController.h"

@implementation Buck2FutureTableViewController

@synthesize budgetEvents = _budgetEvents, yellowLimit = _yellowLimit, redLimit = _redLimit;

-(NSNumber *)yellowLimit
{
    if (!_yellowLimit)
        _yellowLimit = [NSNumber numberWithFloat:100.0];
    return _yellowLimit;
}

-(NSNumber *)redLimit
{
    if (!_redLimit)
        _redLimit = [NSNumber numberWithFloat:20.0];
    return _redLimit;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSNumber *)getNumberFromText:(NSString *)strNum
{
    NSNumber *num;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    [f setNumberStyle:(NSNumberFormatterStyle)NSNumberFormatterBehaviorDefault];
    num = [f numberFromString:strNum];
    if (num)
        return num;
    
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    num = [f numberFromString:strNum];
    if (num)
        return num;

    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    num = [f numberFromString:strNum];
    if (num)
        return num;
    
    return [NSNumber numberWithFloat:0.0];
}

- (void)setBalanceColor:(Buck2UITableViewEventCell *)cel
{
    NSNumber *n = [self getNumberFromText:cel.Balance.text];
    
    if ([n compare:self.redLimit] == NSOrderedAscending)
        cel.Balance.textColor = [UIColor redColor];
    else if ([n compare:self.yellowLimit] == NSOrderedAscending)
        cel.Balance.textColor = [UIColor yellowColor];
    else
        cel.Balance.textColor = [UIColor blackColor];
    
    [cel setNeedsDisplay];
}

- (void)handleLimitChange
{
    for (UITableViewCell* cel in self.table.visibleCells) {
        if ([cel isMemberOfClass:[Buck2UITableViewEventCell class]]) {
            [self setBalanceColor:(Buck2UITableViewEventCell *)cel];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"limitsChanged"
                                                        object:self ];    
}

- (IBAction)redChanged:(UITextField *)sender
{
    self.redLimit = [self getNumberFromText:sender.text];
    [self handleLimitChange];
}

- (IBAction)yellowChanged:(UITextField *)sender
{
    self.yellowLimit = [self getNumberFromText:sender.text];
    [self handleLimitChange];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.budgetEvents count] + 1; // one for the "limits" row
}

//shorthand, used only in the function below
#define RETURNCELL(type, identifier)                                       \
    type *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; \
    if (!cell) cell = [[type alloc] init];                                 \
    return cell;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        RETURNCELL(Buck2UITableViewLimitsCell, @"limitsRow");
    }
    else
    {
        RETURNCELL(Buck2UITableViewEventCell, @"eventRow");
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row] )
    {
        Buck2UITableViewLimitsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"limitsRow"];
        return cell.bounds.size.height;
    }
    Buck2UITableViewEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventRow"];
    return cell.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row )
    {
        Buck2UITableViewLimitsCell *cel = (Buck2UITableViewLimitsCell *)cell;
        
        cel.Yellow.text = [NSString stringWithFormat:@"$%@", self.yellowLimit];
        cel.Red.text = [NSString stringWithFormat:@"$%@", self.redLimit];
    }
    else
    {
        Buck2UITableViewEventCell *cel = (Buck2UITableViewEventCell *)cell;
        Buck2Expense *exp = [self.budgetEvents objectAtIndex:[indexPath row]-1];
        
        cel.Description.text = exp.description;
        cel.Date.text = [exp.date description];
        cel.Amount.text = [NSString stringWithFormat:@"$%@", exp.amount];
        cel.Balance.text = [NSString stringWithFormat:@"$%@", exp.runningTotal];
        
        [self setBalanceColor:cel];
    }
}

@end
