//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DEFAULT_KEYWORD = @"autocultura";
static NSString *const UPLOAD_PLAYLIST = @"ios mobile application";

static NSString *const kClientID = @"621279977102-ngvr3f5gtr1vsooeelscg7javmhhgogh.apps.googleusercontent.com";
static NSString *const kClientSecret = @"Q1CNUdsVZ6f99BNDZ8k8H8Pi";

static NSString *const kKeychainItemName = @"AutoCultura";

@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat;

@end
