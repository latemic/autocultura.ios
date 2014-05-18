//
//  RootFormViewController.h
//  BasicExample
//
//  Created by Nick Lockwood on 25/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "FXForms.h"
#import "GTLYouTube.h"
#import "YouTubeUploadVideo.h"

@protocol YouTubeUploadVideoDelegate;

@interface ACDetailsViewController : FXFormViewController <YouTubeUploadVideoDelegate, UITextFieldDelegate>

@property NSURL *videoURL;
@property (nonatomic) GTLServiceYouTube *youtubeService;

@property(nonatomic, weak) id<YouTubeUploadVideoDelegate> delegate;

// Performs a G+ image search with the given query, will return
// by calling googlePlusImageSearch:didFinishWithResults: when completed.

@end

