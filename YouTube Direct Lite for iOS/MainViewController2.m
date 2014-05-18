//
//  MainViewController.m
//  RoadCulture
//
//  Created by Petro Akzhygitov on 5/18/14.
//  Copyright (c) 2014 Petro Akzhygitov. All rights reserved.
//

#import "MainViewController2.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "Utils.h"
#import "YouTubeGetUploads.h"
#import "VideoListTableViewCell.h"
#import "ACMapViewController.h"

@implementation MainViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    _getUploads = [[YouTubeGetUploads alloc] init];
    _getUploads.delegate = self;

    _videosArray = [[NSArray alloc] init];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Initialize the youtube service & load existing credentials from the keychain if available
    self.youtubeService = [[GTLServiceYouTube alloc] init];
    self.youtubeService.authorizer =
            [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                  clientID:kClientID
                                                              clientSecret:kClientSecret];

    // Helper to check if user is authorized
    if (![self isAuthorized]) {
        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [self.navigationController pushViewController:[self createAuthController] animated:YES];
    } else {
        [self updateVideosList];
    }

    [self iniUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self hideVideoButtons];
    [self updateVideosList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (BOOL)isAuthorized {
    return [((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to YouTube.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;

    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

- (void)iniUI {

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    [self.tableView registerNib:[UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil]
                forCellReuseIdentifier:@"videoCell"];

    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
}

- (void)showVideoButtons {

    if (self.captureVideoButton.hidden) {

        self.captureVideoButton.hidden = NO;
        self.selectVideoButton.hidden = NO;

        [UIView animateWithDuration:.3
                         animations:^(void){
                             self.addVideoButton.alpha = 0;
                             self.captureVideoButtonHorizontalSpaceConstraint.constant += self.captureVideoButton.bounds.size.height;
                             self.selectVideoButtonHorizontalSpaceConstraint.constant += self.selectVideoButton.bounds.size.height;
                             [self.view layoutIfNeeded];
                         }];
    }
}

- (void)hideVideoButtons {

    if (!self.captureVideoButton.hidden) {
         self.addVideoButton.alpha = 1;
         self.captureVideoButtonHorizontalSpaceConstraint.constant -= self.captureVideoButton.bounds.size.height;
         self.selectVideoButtonHorizontalSpaceConstraint.constant -= self.selectVideoButton.bounds.size.height;
         [self.view layoutIfNeeded];

         self.captureVideoButton.hidden = YES;
         self.selectVideoButton.hidden = YES;
    }
}

- (void)updateVideosList {

    if (!self.videosArray.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    if (self.isAuthorized) {
        [self.getUploads getYouTubeUploadsWithService:self.youtubeService];
    }
}

- (IBAction)addVideoButtonClick:(id)sender {
    [self showVideoButtons];
}

- (IBAction)selectVideoButtonClick:(id)sender {

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    // In case we're running the iPhone simulator, fall back on the photo library instead.
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [Utils showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
        return;
    }
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (IBAction)captureVideoButtonClick:(id)sender {

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [Utils showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
            return;
        }
    }
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}


// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
//        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
        self.youtubeService.authorizer = nil;

    } else {
        self.youtubeService.authorizer = authResult;
        [self updateVideosList];
    }
}

#pragma mark - YouTubeGetUploadsDelegate methods

- (void)getYouTubeUploads:(YouTubeGetUploads *)getUploads didFinishWithResults:(NSArray *)results {

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.videosArray = results;

    if (self.videosArray.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const kReuseIdentifier = @"videoCell";

    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];

    VideoData *vidData = [self.videosArray objectAtIndex:indexPath.row];
    cell.videoThumb.image = vidData.thumbnail;
    cell.titleLabel.text = [vidData getTitle];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videosArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoData *selectedVideo = [_videosArray objectAtIndex:indexPath.row];

/*    VideoPlayerViewController *videoController = [[VideoPlayerViewController alloc] init];
    videoController.videoData = selectedVideo;
    videoController.youtubeService = self.youtubeService;

    [[self navigationController] pushViewController:videoController animated:YES];*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {

}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if (CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {

        self.videoURL = [info objectForKey:UIImagePickerControllerMediaURL];

        [self performSegueWithIdentifier:@"pushMapViewControllerSegue" sender:nil];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if([segue.identifier isEqualToString:@"pushMapViewControllerSegue"]){
        ((ACMapViewController *)segue.destinationViewController).videoURL = self.videoURL;
        ((ACMapViewController *)segue.destinationViewController).youtubeService = self.youtubeService;
    }
}


@end
