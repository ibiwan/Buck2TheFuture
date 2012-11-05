//
//  Buck2Expense.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/10/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2Expense.h"

@implementation Buck2Expense

@synthesize description = _description,
            date = _date,
            amount = _amount,
            repeats = _repeats,
            frequency = _frequency,
            units = _units;


-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
{
    self = [super init];
    self.description = description;
    self.date = date;
    self.amount = amount;
    self.repeats = NO;
    return self;
}

-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
                           frequency:(NSNumber *)frequency
                               units:(NSString *)units
{
    self = [self initWithDescription:description date:date amount:amount];
    self.frequency = frequency;
    self.units = units;
    self.repeats = YES;
    return self;
}

-(Buck2Expense *)initWithDict:(NSDictionary *)dict {
    return [self initWithDescription:[dict objectForKey:@"description"]
                                date:[dict objectForKey:@"date"]
                              amount:[dict objectForKey:@"amount"]
                           frequency:[dict objectForKey:@"frequency"]
                               units:[dict objectForKey:@"units"]];
}

-(NSDictionary *)dict {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.description, @"description",
            self.date, @"date",
            self.amount, @"amount",
            self.frequency, @"frequency",
            self.units, @"units",
            nil];
}

-(Buck2Expense *)copy
{
    Buck2Expense *cp = [[Buck2Expense alloc] initWithDescription:self.description
                                                            date:self.date
                                                          amount:self.amount
                                                       frequency:self.frequency
                                                           units:self.units];
    cp.repeats = self.repeats;
    return cp;
}

-(void)toggleRepeats
{
    self.repeats = !self.repeats;
}


@end
