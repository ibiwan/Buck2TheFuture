//
//  Buck2Expense.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/10/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNITS_DAYS        @"days"
#define UNITS_WEEKS       @"weeks"
#define UNITS_MONTHS      @"months"
#define UNITS_YEARS       @"years"
#define KEY_DSCR          @"description"
#define KEY_DATE          @"date"
#define KEY_AMNT          @"amount"
#define KEY_TYPE          @"event_type"
#define KEY_RPTS          @"repeats"
#define KEY_FREQ          @"frequency"
#define KEY_UNIT          @"units"
#define KEY_EXPS          @"expenses"

typedef enum {
    Income,
    Expense,
    Balance
} eventType;

@interface Buck2Expense : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic) BOOL repeats;
@property (nonatomic, strong) NSNumber *frequency;
@property (nonatomic, strong) NSString *units;
@property (nonatomic) eventType type;
@property (nonatomic, strong) NSNumber *runningTotal;

-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
                                type:(eventType)type;

-(Buck2Expense *)initWithDescription:(NSString *)description
                                date:(NSDate *)date
                              amount:(NSNumber *)amount
                                type:(eventType)type
                           frequency:(NSNumber *)frequency
                               units:(NSString *)units;

-(Buck2Expense *)initWithDict:(NSDictionary *)dict;
-(NSDictionary *)dict;

-(Buck2Expense *)copy;

-(void)toggleRepeats;

@end
