//
//  RootFormViewController.m
//  BasicExample
//
//  Created by Nick Lockwood on 25/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ACDetailsViewController.h"
#import "ACDetailsForm.h"
#import "Utils.h"


@implementation ACDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        //set up form
        self.formController.form = [[ACDetailsForm alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //set up form
        self.formController.form = [[ACDetailsForm alloc] init];
    }
    return self;
}

//these are action methods for our forms
//the methods escalate through the responder chain until
//they reach the AppDelegate

- (void)submitForm {

    NSData *fileData = [NSData dataWithContentsOfURL:self.videoURL];
    NSString *title = ((ACDetailsForm *)self.formController.form).about;
    NSString *description = ((ACDetailsForm *)self.formController.form).about;

    GTLYouTubeVideo *video = [GTLYouTubeVideo object];
    GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet alloc];
    GTLYouTubeVideoStatus *status = [GTLYouTubeVideoStatus alloc];
    status.privacyStatus = @"public";
    snippet.title = title;
    snippet.descriptionProperty = description;
    snippet.tags = [NSArray arrayWithObjects:DEFAULT_KEYWORD, UPLOAD_PLAYLIST, nil];
    video.snippet = snippet;
    video.status = status;

    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileData MIMEType:@"video/*"];
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video part:@"snippet,status" uploadParameters:uploadParameters];

    [self.youtubeService executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket,
                GTLYouTubeVideo *insertedVideo, NSError *error) {

            if (error == nil)
            {
                NSLog(@"File ID: %@", insertedVideo.identifier);
                [Utils showAlert:@"Авто Культура" message:@"Ваша заявка подана!"];
                [self.delegate uploadYouTubeVideo:self didFinishWithResults:insertedVideo];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
            else
            {
                NSLog(@"An error occurred: %@", error);
                [Utils showAlert:@"Авто Культура" message:@"Не удалось подать заявку!"];
                [self.delegate uploadYouTubeVideo:self didFinishWithResults:nil];
                return;
            }
        }];
}

- (void)submitDetailsForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    ACDetailsForm *form = cell.field.form;
    
    //we can then perform validation, etc
    if (form.agreedToTerms)
    {
        [self submitForm];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Авто Культура" message:@"Вам необоходимо принять условия соглашения!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Принять", nil] show];
    }
}

@end
