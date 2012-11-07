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
        _yellowLimit = [NSNumber numberWithDouble:100.0];
    return _yellowLimit;
}

-(NSNumber *)redLimit
{
    if (!_redLimit)
        _redLimit = [NSNumber numberWithDouble:20.0];
    return _redLimit;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (0 == [indexPath row])
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
    if (0 == [indexPath row] )
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
        cel.Balance.text = [NSString stringWithFormat:@"$%@", exp.amount];
        if (exp.amount > self.yellowLimit)
            cel.Balance.textColor = [UIColor yellowColor];
        if (exp.amount > self.redLimit)
            cel.Balance.textColor = [UIColor redColor];
    }
}

@end
