//
//  RegistrationForm.m
//  BasicExample
//
//  Created by Nick Lockwood on 04/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "ACDetailsForm.h"


@implementation ACDetailsForm

//because we want to rearrange how this form
//is displayed, we've implemented the fields array
//which lets us dictate exactly which fields appear
//and in what order they appear

- (NSArray *)fields
{
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group
             
             @{FXFormFieldKey: @"type",
               FXFormFieldOptions: @[@"Нарушение ПДД", @"ДТП", @"Действия ГАИ"],
               FXFormFieldTitle: @"Происшествие"},
             @{FXFormFieldKey: @"carPlateNumber",
               FXFormFieldTitle: @"Номер авто",
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeAllCharacters)  },
             @{FXFormFieldKey: @"about",
               FXFormFieldTitle: @"Подробности",
               FXFormFieldType: FXFormFieldTypeLongText},
             
             //we want to add a section header here, so we use another config dictionary
             
             @{FXFormFieldKey: @"termsAndConditions",
               FXFormFieldTitle: @"Правила использования",
               FXFormFieldHeader: @"Подтверждение"},
             //the automatically generated title (Agreed To Terms) and cell (FXFormSwitchCell)
             //don't really work for this field, so we'll override them both (a type of
             //FXFormFieldTypeOption will use an checkmark instead of a switch by default)
             
             @{FXFormFieldKey: @"agreedToTerms",
               FXFormFieldTitle: @"Я согласен с правилами",
               FXFormFieldType: FXFormFieldTypeOption},
             
             //this field doesn't correspond to any property of the form
             //it's just an action button. the action will be called on first
             //object in the responder chain that implements the submitForm
             //method, which in this case would be the AppDelegate
             
             @{FXFormFieldTitle: @"Отправить", FXFormFieldHeader: @"", FXFormFieldAction: @"submitDetailsForm:"},
             ];
}

@end
