//
//  Buck2UITableViewEventCell.h
//  Buck 2 the Future
//
//  Created by Jeremiah Kent on 11/7/12.
//  Copyright (c) 2012 Jeremiah Kent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Buck2UITableViewEventCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *Description;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *Amount;
@property (strong, nonatomic) IBOutlet UILabel *Balance;

@end
