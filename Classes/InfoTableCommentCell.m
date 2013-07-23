//
//  InfoTableCommentCell.m
//  How To Chess
//
//  Created by Sharon Hao on 8/9/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "InfoTableCommentCell.h"

@implementation InfoTableCommentCell

@synthesize commentText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
