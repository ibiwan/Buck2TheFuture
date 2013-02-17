//
//  Buck2UITableViewRepeatingExpenseCell.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 9/6/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2UITableViewRepeatingExpenseCell.h"
#import "Buck2IntervalPickerView.h"
#import "Buck2Expense.h"

@interface Buck2UITableViewRepeatingExpenseCell ()

@property (strong, nonatomic) Buck2IntervalPickerView *intervalPicker;
@property (strong, nonatomic) NSArray *unitOptions;

@end

@implementation Buck2UITableViewRepeatingExpenseCell

@synthesize howOften = _howOften;
@synthesize units = _units;
@synthesize intervalPicker = _intervalPicker;
@synthesize unitOptions = _unitOptions;

- (id) intervalPicker {
    if (!_intervalPicker) {
        _intervalPicker = [Buck2IntervalPickerView sharedIntervalPicker];
    }
    return _intervalPicker;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        [self awakeFromNib];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.intervalPicker.delegate = self;
    self.units.inputView = self.intervalPicker;
    self.unitOptions = [NSArray arrayWithObjects:UNITS_DAYS, UNITS_WEEKS, UNITS_MONTHS, UNITS_YEARS, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.units.text = [self.unitOptions objectAtIndex:row];
    [self.units setNeedsDisplay];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4; //days, weeks, months, years
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *ret = [self.unitOptions objectAtIndex:row];
    if (ret) return ret;
    return [self.unitOptions objectAtIndex:0];

}

@end
