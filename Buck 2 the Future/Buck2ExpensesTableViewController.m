//
//  Buck2ExpensesTableViewController.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2ExpensesTableViewController.h"
#import "Buck2FutureTableViewController.h"
#import "Buck2UITableViewRepeatingExpenseCell.h"
#import "Buck2UITableViewExpenseCell.h"
#import "Buck2UITableViewNewExpenseCell.h"
#import "Buck2CrystalBall.h"

@interface Buck2ExpensesTableViewController ()

@property (nonatomic, strong) Buck2CrystalBall *crystalBall;

@end

@implementation Buck2ExpensesTableViewController

@synthesize crystalBall = _crystalBall;

- (Buck2CrystalBall *)crystalBall
{
    if (!_crystalBall) {
        _crystalBall = [[Buck2CrystalBall alloc ] init];
    }
    return _crystalBall;
}

- (void)loadDummyData
{
    [self.crystalBall addExpense:@"dentist"
                          onDate:[NSDate date]
                      withAmount:[NSNumber numberWithDouble:25.00]];
    [self.crystalBall addExpense:@"cassidy"
                          onDate:[NSDate date]
                      withAmount:[NSNumber numberWithDouble:35.00]
             withRepetitionEvery:[NSNumber numberWithInt:2]
                          ofUnit:UNITS_WEEKS];
}

- (void)awakeFromNib
{
    if (![self.crystalBall loadFromDeaults])
        [self loadDummyData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
        [self awakeFromNib];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:()sender
{
    NSMutableArray *budgetEvents = [[NSMutableArray alloc] init];
    NSDate *now = [[NSDate alloc] init];
    NSDate *expenseDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    while ([self.crystalBall expenseCount] > 0
           && expenseDate < now)
    {
        Buck2Expense *expense = [self.crystalBall getNextExpense];
        [budgetEvents addObject:expense];
        expenseDate = expense.date;
    }
    if ([segue.identifier isEqualToString:@"segueToFuture"]) {
        Buck2FutureTableViewController *target = (Buck2FutureTableViewController*)segue.destinationViewController;
        target.budgetEvents = budgetEvents;
        target.yellowLimit = [NSNumber numberWithDouble:200.0];
        target.redLimit = [NSNumber numberWithDouble:5.0];
    }
}

#pragma mark - Modify Row

- (IBAction)descriptionChanged:(UITextField *)sender
{
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    expense.description = sender.text;
    [self.crystalBall saveToDefaults];
}

- (IBAction)amountChanged:(UITextField *)sender
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    Buck2Expense *expense = [self.crystalBall expenseAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    expense.amount = [f numberFromString:sender.text];
    if (expense.amount == nil)
    {
        expense.amount = [NSNumber numberWithFloat:0.0];
        sender.text = [expense.amount stringValue];
    }
    [self.crystalBall saveToDefaults];
}

- (IBAction)dateChanged:(UITextField *)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    expense.date = [df dateFromString: sender.text];
    if (expense.date == nil)
    {
        expense.date = [NSDate date];
        sender.text = [df stringFromDate:expense.date];
    }
    [self.crystalBall saveToDefaults];
}

- (IBAction)frequencyChanged:(UITextField *)sender
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    Buck2Expense *expense = [self.crystalBall expenseAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    expense.frequency = [f numberFromString:sender.text];
    if (expense.amount == nil)
    {
        expense.amount = [NSNumber numberWithInt:1];
        sender.text = [expense.amount stringValue];
    }
    [self.crystalBall saveToDefaults];
}

- (IBAction)unitsChanged:(UITextField *)sender
{
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    expense.units = sender.text;
    [self.crystalBall saveToDefaults];
}

- (IBAction)toggleRepeat:(UISwitch *)sender {
    [self.crystalBall toggleRepeatAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    [self.crystalBall saveToDefaults];
    [self.tableView reloadData];
}

#pragma mark - Modify Table (add/remove row)

- (IBAction)addExpense {
    [self.crystalBall addExpense:@""
                          onDate:[[NSDate alloc] init]
                      withAmount:[NSNumber numberWithDouble:0.0]];
    [self.crystalBall saveToDefaults];
    [self.tableView reloadData];
}

- (IBAction)deleteExpense:(UIButton *)sender {
    [self.crystalBall deleteEventAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    [self.crystalBall saveToDefaults];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.crystalBall expenseCount] + 1; // one for the "add row" row
}

//shorthand, used only in the function below
#define RETURNCELL(type, identifier)                                       \
    type *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; \
    if (!cell) cell = [[type alloc] init];                                 \
    return cell;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.crystalBall expenseCount] == [indexPath row] )
    {
        RETURNCELL(Buck2UITableViewNewExpenseCell, @"newExpenseRow");
    }
    if ([self.crystalBall expenseAtIndex:[indexPath row]].repeats)
    {
        RETURNCELL(Buck2UITableViewRepeatingExpenseCell, @"repeatingExpenseRow");
    }
    RETURNCELL(Buck2UITableViewExpenseCell, @"expenseRow");
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.crystalBall expenseCount] == [indexPath row] )
    {
        Buck2UITableViewNewExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newExpenseRow"];
        return cell.bounds.size.height;
    }

    Buck2Expense *expense = [self.crystalBall expenseAtIndex:
                             [indexPath row]];
    
    static NSString *CellIdentifier;
    if (expense.repeats)
        CellIdentifier = @"repeatingExpenseRow";
    else
        CellIdentifier = @"expenseRow";
    Buck2UITableViewExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(Buck2UITableViewExpenseCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.crystalBall expenseCount] == [indexPath row] )
        return;
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[indexPath row]];
    
    cell.description.text = expense.description;
    cell.amount.text = [expense.amount stringValue];
    cell.date.text = [expense.date description];
    cell.row = [indexPath row];
    [cell.repeatSwitch setOn:NO animated:YES];

    if ([cell isKindOfClass:[Buck2UITableViewRepeatingExpenseCell class]]) {
        [cell.repeatSwitch setOn:YES animated:YES];
        ((Buck2UITableViewRepeatingExpenseCell *)cell).howOften.text = [expense.frequency stringValue];
        ((Buck2UITableViewRepeatingExpenseCell *)cell).units.text = expense.units;
    }
}
@end
