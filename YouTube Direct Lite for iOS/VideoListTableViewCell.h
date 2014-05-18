//
//  VideoListTableViewCell.h
//  autoculture
//
//  Created by Petro Akzhygitov on 5/18/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumb;
@end
