//
//  Buck2CrystalBall.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2CrystalBall.h"

@interface Buck2CrystalBall()

@property (strong, nonatomic) NSMutableArray *expenses;
@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation Buck2CrystalBall

@synthesize expenses = _expenses;
@synthesize calendar = _calendar;

-(NSMutableArray *)expenses
{
    if (!_expenses)
        _expenses = [[NSMutableArray alloc] init];
    return _expenses;
}

-(NSCalendar *)calendar
{
    if (!_calendar)
        _calendar = [NSCalendar currentCalendar];
    return _calendar;
}

-(void)addExpense:(Buck2Expense *)expense
{
    [self.expenses addObject:expense];
    [self.expenses sortUsingComparator:
     ^NSComparisonResult(Buck2Expense *expense1, Buck2Expense *expense2)
    {
        return [expense1.date compare:expense2.date];
    }];
}

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount
{
    Buck2Expense *expense = [[Buck2Expense alloc] initWithDescription:description date:date amount:amount];
    [self addExpense:expense];
}

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount withRepetitionEvery:(NSNumber *)n ofUnit:(NSString *)units
{
    Buck2Expense *expense = [[Buck2Expense alloc] initWithDescription:description date:date amount:amount frequency:n units:units];
    [self addExpense:expense];
}

-(void)clearExpenses
{
    self.expenses = nil;
}

-(Buck2Expense *)getNextExpense
{
    Buck2Expense *nextExpense = [self.expenses lastObject];
    if (self.expenses.count > 0)
        [self.expenses removeObject:nextExpense];
    if (nextExpense.repeats)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        if ([nextExpense.units isEqualToString:UNITS_DAYS])
            [components setDay:[nextExpense.frequency integerValue]];
        if ([nextExpense.units isEqualToString:UNITS_WEEKS])
            [components setWeek:[nextExpense.frequency integerValue]];
        if ([nextExpense.units isEqualToString:UNITS_MONTHS])
            [components setMonth:[nextExpense.frequency integerValue]];
        if ([nextExpense.units isEqualToString:UNITS_YEARS])
            [components setYear:[nextExpense.frequency integerValue]];
        NSDate *followingDate = [[NSCalendar currentCalendar]
                                 dateByAddingComponents:components toDate:nextExpense.date options:0];
        Buck2Expense *followingExpense = [nextExpense copy];
        followingExpense.date = followingDate;
        [self addExpense: followingExpense];
    }
    return nextExpense;
}

-(Buck2Expense *)expenseAtIndex:(NSUInteger) index
{
    Buck2Expense *e = [self.expenses objectAtIndex:index];
    return e;
}

-(NSUInteger)expenseCount
{
    return self.expenses.count;
}

-(void)toggleRepeatAtIndex:(NSUInteger)index
{
    [[self.expenses objectAtIndex:index] toggleRepeats];
}

-(void)deleteEventAtIndex:(NSUInteger)index
{
    [self.expenses removeObjectAtIndex:index];
}

-(void)saveToDefaults
{
    NSMutableArray *expenseDicts = [[NSMutableArray alloc] init];
    for (Buck2Expense *expense in self.expenses) {
        [expenseDicts addObject:[expense dict]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:expenseDicts forKey:@"expenses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)loadFromDeaults
{
    [self clearExpenses];
    NSArray *expenseDicts = [[NSUserDefaults standardUserDefaults] objectForKey:@"expenses"];
    for (NSDictionary *dict in expenseDicts) {
        Buck2Expense *expense = [[Buck2Expense alloc] initWithDict:dict];
        [self addExpense:expense];
    }
    if ([expenseDicts count] > 0)
        return YES;
    return NO;
}
@end
