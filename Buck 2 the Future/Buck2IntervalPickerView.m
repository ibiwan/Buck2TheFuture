//
//  Buck2IntervalPickerView.m
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 10/9/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import "Buck2IntervalPickerView.h"

@implementation Buck2IntervalPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsSelectionIndicator = true;    }
    return self;
}

+ (Buck2IntervalPickerView *) sharedIntervalPicker {
    static Buck2IntervalPickerView *shared;
    if (!shared) {
        shared = [[Buck2IntervalPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    }
    return shared;
}

@end
