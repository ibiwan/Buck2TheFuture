//
//  Buck2CrystalBall.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/5/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Buck2Expense.h"

@interface Buck2CrystalBall : NSObject

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount;

-(void)addExpense:(NSString *)description onDate:(NSDate *) date withAmount:(NSNumber *)amount withRepetitionEvery:(NSNumber *)n ofUnit:(NSString *)units;

-(void)clearExpenses;

-(Buck2Expense *)getNextExpense;

-(Buck2Expense *)expenseAtIndex:(NSUInteger)index;

-(NSUInteger)expenseCount;

-(void)toggleRepeatAtIndex:(NSUInteger)index;

-(void)deleteEventAtIndex:(NSUInteger)index;

-(void)saveToDefaults;
-(BOOL)loadFromDefaults;

-(Buck2CrystalBall *)copy;

@end
