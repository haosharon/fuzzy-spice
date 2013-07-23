//
//  InfoTableCommentCell.h
//  How To Chess
//
//  Created by Sharon Hao on 8/9/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableCommentCell : UITableViewCell {
    UITextView *commentText;

}

@property (nonatomic, retain) IBOutlet UITextView *commentText;

@end
