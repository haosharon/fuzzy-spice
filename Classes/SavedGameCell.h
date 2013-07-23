//
//  SavedGameCell.h
//  How To Chess
//
//  Created by Sharon Hao on 8/7/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedGameCell : UITableViewCell {
	IBOutlet UILabel *titleLabel;
	IBOutlet UIImageView *icon;
	IBOutlet UILabel *dateLabel;

}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *dateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *icon;

@end
