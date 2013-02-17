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
- (Buck2CrystalBall *)initWithArray:(NSArray *)array;
- (BOOL)loadFromArray:(NSArray *)array;
- (NSArray *)array;

@end

@implementation Buck2CrystalBall

@synthesize expenses = _expenses;
@synthesize calendar = _calendar;
@synthesize redLimit = _redLimit;
@synthesize yellowLimit = _yellowLimit;

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

-(void)addExpense:(Buck2Expense *)expense toArray:(NSMutableArray *)array {
    [array addObject:expense];
    [array sortUsingComparator:
     ^NSComparisonResult(Buck2Expense *expense1, Buck2Expense *expense2)
     {
         return [expense1.date compare:expense2.date];
     }];    
}

-(void)addExpense:(Buck2Expense *)expense
{
    [self addExpense:expense toArray:self.expenses];
}

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount asType:(eventType)type
{
    Buck2Expense *expense = [[Buck2Expense alloc] initWithDescription:description date:date amount:amount type:type];
    [self addExpense:expense];
}

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount asType:(eventType)type withRepetitionEvery:(NSNumber *)n ofUnit:(NSString *)units
{
    Buck2Expense *expense = [[Buck2Expense alloc] initWithDescription:description date:date amount:amount type:type frequency:n units:units];
    [self addExpense:expense];
}

-(void)clearExpenses
{
    self.expenses = nil;
}

-(NSDate *)getDateFollowing:(NSDate *)date withUnits:(NSString *)units andCount:(NSNumber *)frequency {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    if ([units isEqualToString:UNITS_DAYS])
        [components setDay:[frequency integerValue]];
    if ([units isEqualToString:UNITS_WEEKS])
        [components setWeek:[frequency integerValue]];
    if ([units isEqualToString:UNITS_MONTHS])
        [components setMonth:[frequency integerValue]];
    if ([units isEqualToString:UNITS_YEARS])
        [components setYear:[frequency integerValue]];
    return [[NSCalendar currentCalendar]
            dateByAddingComponents:components toDate:date options:0];
    
}

-(NSArray *)getEventsFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSMutableArray *scratch = [[NSMutableArray alloc] init];
    for (Buck2Expense *expense in self.expenses) {
        NSComparisonResult order = [expense.date compare:endDate];
        if (order == NSOrderedAscending || order == NSOrderedSame) {
            [self addExpense:expense toArray:scratch];
        }
    }
    while (scratch.count > 0) {
        Buck2Expense *expense = [scratch lastObject];
        [scratch removeObject:expense];
        // if event is after start date, add it to events.
        // otherwise, just add its repetition to scratch to re-evalulate
        NSComparisonResult order = [expense.date compare:startDate];
        if (order == NSOrderedDescending || order == NSOrderedSame) {
            [self addExpense:expense toArray:events];
        }
        if (expense.repeats) {
            NSDate *repeatDate = [self getDateFollowing:expense.date
                                              withUnits:expense.units
                                               andCount:expense.frequency];
            NSComparisonResult order = [repeatDate compare:endDate];
            if (order == NSOrderedAscending || order == NSOrderedSame) {
                Buck2Expense *repeatExpense = [expense copy];
                repeatExpense.date = repeatDate;
                [self addExpense:repeatExpense toArray:scratch];
            }
        }
    }
    return [events copy];
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

- (BOOL)loadFromArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        Buck2Expense *expense = [[Buck2Expense alloc] initWithDict:dict];
        [self addExpense:expense];
    }
    return (self.expenseCount > 0);
}

- (Buck2CrystalBall *)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        [self loadFromArray:array];
    }
    return self;
}

- (NSArray *)array
{
    NSMutableArray *expenseDicts = [[NSMutableArray alloc] init];
    for (Buck2Expense *expense in self.expenses) {
        [expenseDicts addObject:[expense dict]];
    }
    return [expenseDicts copy];
}

-(void)saveToDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[self array] forKey:KEY_EXPS];
    [[NSUserDefaults standardUserDefaults] setObject:self.yellowLimit forKey:KEY_YEL];
    [[NSUserDefaults standardUserDefaults] setObject:self.redLimit forKey:KEY_RED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)loadFromDefaults
{
    self.yellowLimit = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_YEL];
    self.redLimit = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_RED];
    NSArray *expenseDicts = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_EXPS];
    if (expenseDicts) {
        [self clearExpenses];
        return [self loadFromArray:expenseDicts];
    }
    return NO;
}

-(Buck2CrystalBall *)copy
{
    return [[Buck2CrystalBall alloc] initWithArray:[self array]];
}

@end
