//
//  SavedGameCell.m
//  How To Chess
//
//  Created by Sharon Hao on 8/7/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "SavedGameCell.h"


@implementation SavedGameCell

@synthesize titleLabel, dateLabel;
@synthesize icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
