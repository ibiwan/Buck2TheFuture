//
//  Buck2CrystalBall.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Buck2Expense.h"

#define KEY_RED @"redLimit"
#define KEY_YEL @"yellowLimit"

@interface Buck2CrystalBall : NSObject

@property (strong, nonatomic) NSNumber *redLimit;
@property (strong, nonatomic) NSNumber *yellowLimit;

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount asType:(eventType)type;
-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount asType:(eventType)type withRepetitionEvery:(NSNumber *)n ofUnit:(NSString *)units;

-(void)clearExpenses;

-(NSArray *)getEventsFrom:(NSDate *)startDate to:(NSDate *)endDate;
-(Buck2Expense *)expenseAtIndex:(NSUInteger)index;
-(NSUInteger)expenseCount;

-(void)toggleRepeatAtIndex:(NSUInteger)index;
-(void)deleteEventAtIndex:(NSUInteger)index;

-(void)saveToDefaults;
-(BOOL)loadFromDefaults;

-(Buck2CrystalBall *)copy;

@end
