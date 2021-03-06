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
            type = _type,
            repeats = _repeats,
            frequency = _frequency,
            units = _units,
            runningTotal = _runningTotal;


-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
                                type:(eventType)type
{
    self = [super init];
    if (self) {
        self.description = description;
        self.date = date;
        self.amount = amount;
        self.type = type;
        self.repeats = NO;
    }
    return self;
}

-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
                                type:(eventType)type
                           frequency:(NSNumber *)frequency
                               units:(NSString *)units
{
    self = [self initWithDescription:description date:date amount:amount type:type];
    self.frequency = frequency;
    self.units = units;
    self.repeats = YES;
    return self;
}

-(Buck2Expense *)initWithDict:(NSDictionary *)dict {
    if ([(NSNumber*)[dict objectForKey:KEY_RPTS] boolValue])
        return [self initWithDescription:[dict objectForKey:KEY_DSCR]
                                    date:[dict objectForKey:KEY_DATE]
                                  amount:[dict objectForKey:KEY_AMNT]
                                    type:[(NSNumber *)[dict objectForKey:KEY_TYPE] intValue]
                               frequency:[dict objectForKey:KEY_FREQ]
                                   units:[dict objectForKey:KEY_UNIT]];
    else
        return [self initWithDescription:[dict objectForKey:KEY_DSCR]
                                    date:[dict objectForKey:KEY_DATE]
                                  amount:[dict objectForKey:KEY_AMNT]
                                    type:[(NSNumber *)[dict objectForKey:KEY_TYPE] intValue]];
}

-(NSDictionary *)dict {
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  self.description, KEY_DSCR,
                                  self.date,        KEY_DATE,
                                  self.amount,      KEY_AMNT,
                                  [NSNumber numberWithInt:self.type],
                                                    KEY_TYPE,
                                  [NSNumber numberWithBool:self.repeats],
                                                    KEY_RPTS,
                                  nil];
    if (self.repeats) {
        [mdict setValue:self.frequency  forKey:KEY_FREQ];
        [mdict setValue:self.units      forKey:KEY_UNIT];
    }
    return [mdict copy];
}

-(Buck2Expense *)copy
{
    Buck2Expense *cp = [[Buck2Expense alloc] initWithDescription:self.description
                                                            date:self.date
                                                          amount:self.amount
                                                            type:self.type
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
