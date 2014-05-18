//
//  RegistrationForm.h
//  BasicExample
//
//  Created by Nick Lockwood on 04/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACTermsViewController.h"
#import "FXForms.h"

@interface ACDetailsForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *carPlateNumber;
@property (nonatomic, copy) NSString *about;

@property (nonatomic, copy) NSString *notifications;

@property (nonatomic, readonly) ACTermsViewController *termsAndConditions;
@property (nonatomic, assign) BOOL agreedToTerms;

@end
