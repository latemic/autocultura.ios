//
//  ACMapViewController.h
//  autocultura
//
//  Created by Denys Nikolayenko on 5/18/14.
//  Copyright (c) 2014 ___AUTOCULTURA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GTLYouTube.h"

@interface ACMapViewController : UIViewController

@property NSURL *videoURL;
@property (nonatomic) GTLServiceYouTube *youtubeService;

@end
