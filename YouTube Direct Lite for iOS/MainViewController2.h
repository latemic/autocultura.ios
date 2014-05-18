//
//  MainViewController.h
//  RoadCulture
//
//  Created by Petro Akzhygitov on 5/18/14.
//  Copyright (c) 2014 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLYouTube.h"
#import "VideoData.h"
#import "YouTubeGetUploads.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MainViewController2 : UIViewController <UINavigationControllerDelegate,
                                                    UISearchBarDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    UINavigationControllerDelegate,
                                                    YouTubeGetUploadsDelegate>



@property NSURL *videoURL;
@property (nonatomic) NSArray *videosArray;
@property (nonatomic) GTLServiceYouTube *youtubeService;
@property(nonatomic, strong) YouTubeGetUploads *getUploads;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *captureVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *addVideoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectVideoButtonHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureVideoButtonHorizontalSpaceConstraint;

@end
