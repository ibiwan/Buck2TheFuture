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
                      withAmount:[NSNumber numberWithFloat:25.00]
                          asType:Expense];
    [self.crystalBall addExpense:@"cassidy"
                          onDate:[NSDate date]
                      withAmount:[NSNumber numberWithFloat:35.00]
                          asType:Expense
             withRepetitionEvery:[NSNumber numberWithInt:2]
                          ofUnit:UNITS_WEEKS];
}

- (void)awakeFromNib
{
    if (![self.crystalBall loadFromDefaults])
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
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

-(void) viewDidUnload
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
    if ([segue.identifier isEqualToString:@"segueToFuture"]) {
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        [interval setMonth:3];
        NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:interval
                                                                    toDate:[[NSDate alloc] init]
                                                                   options:0];
        NSArray *events = [self.crystalBall getEventsFrom:[NSDate distantPast] to:end];
        float runningTotal = 0.0;
        for (Buck2Expense *event in events) {
            switch (event.type) {
                case Income:
                    runningTotal += [event.amount floatValue];
                    break;
                case Balance:
                    runningTotal = [event.amount floatValue];
                    break;
                default: // assume Expense
                    runningTotal -= [event.amount floatValue];
                    break;
            }
            event.runningTotal = [NSNumber numberWithFloat:runningTotal];
        }
        Buck2FutureTableViewController *target = (Buck2FutureTableViewController*)segue.destinationViewController;
        target.budgetEvents = events;
        target.yellowLimit = self.crystalBall.yellowLimit;
        target.redLimit = self.crystalBall.redLimit;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(limitsChanged:)
                                                     name:@"limitsChanged"
                                                   object:nil ];
    }
}

#pragma mark - Modify Row

- (void) limitsChanged:(NSNotification *)n
{
    Buck2FutureTableViewController *future = n.object;
    self.crystalBall.yellowLimit = future.yellowLimit;
    self.crystalBall.redLimit = future.redLimit;
    [self.crystalBall saveToDefaults];
}

- (Buck2UITableViewExpenseCell *) cellFromSender:(UIControl *)sender
{
    return (Buck2UITableViewExpenseCell *)sender.superview.superview;
}

- (NSInteger) indexFromSender:(UIControl *)sender
{
    return [self cellFromSender:sender].row;
}

- (IBAction)descriptionChanged:(UITextField *)sender
{
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[self indexFromSender:sender]];
    expense.description = sender.text;
    [self.crystalBall saveToDefaults];
}

- (IBAction)amountChanged:(UITextField *)sender
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[self indexFromSender:sender]];
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
    
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[self indexFromSender:sender]];
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

    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[self indexFromSender:sender]];
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
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:[self indexFromSender:sender]];
    expense.units = sender.text;
    [self.crystalBall saveToDefaults];
}

- (IBAction)toggleRepeat:(UISwitch *)sender {
    [self.crystalBall toggleRepeatAtIndex:[self indexFromSender:sender]];
    [self.crystalBall saveToDefaults];
    [self.tableView reloadData];
}

- (IBAction)toggleType:(UIButton *)sender {
    Buck2UITableViewExpenseCell *cell =[self cellFromSender:sender];
    Buck2Expense *expense = [self.crystalBall expenseAtIndex:cell.row];
    switch (expense.type) {
        case Expense:
            expense.type = Income;
            break;
        case Income:
            expense.type = Balance;
            break;
        default: // start with Expense if unknown
            expense.type = Expense;
            break;
    }
    cell.type = expense.type;
    [cell colorFlow];
}

#pragma mark - Modify Table (add/remove row)

- (IBAction)deleteExpense:(UIButton *)sender {
    [self.crystalBall deleteEventAtIndex:((Buck2UITableViewExpenseCell *)(sender.superview.superview)).row];
    [self.crystalBall saveToDefaults];
    [self.tableView reloadData];
}

- (IBAction)addRow:(UIButton *)sender {
    eventType type = Expense;
    if ([sender.titleLabel.text isEqualToString:@"Income"])
        type = Income;
    if ([sender.titleLabel.text isEqualToString:@"Balance"])
        type = Balance;
    [self.crystalBall addExpense:@""
                              onDate:[[NSDate alloc] init]
                          withAmount:[NSNumber numberWithFloat:0.0]
                              asType:type];
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
    cell.type = expense.type;
    [cell.repeatSwitch setOn:NO animated:YES];

    if ([cell isKindOfClass:[Buck2UITableViewRepeatingExpenseCell class]]) {
        [cell.repeatSwitch setOn:YES animated:YES];
        ((Buck2UITableViewRepeatingExpenseCell *)cell).howOften.text = [expense.frequency stringValue];
        ((Buck2UITableViewRepeatingExpenseCell *)cell).units.text = expense.units;
    }
    [cell colorFlow];
}
@end
