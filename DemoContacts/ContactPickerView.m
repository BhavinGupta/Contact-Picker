//
//  ContactPickerView.m
//  DemoContacts
//
//  Created by Bhavin Gupta on 09/01/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "ContactPickerView.h"

@implementation ContactPickerView

#pragma mark - Initializing The Contact Picker
- (id)initWithViewController:(UIViewController *)viewController{
    if(self == [super init]){
        ABPeoplePickerNavigationController* peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        if ([peoplePicker respondsToSelector:@selector(predicateForEnablingPerson)]) {
            // People Picker disbale the contact which don't have phone number
            peoplePicker.predicateForEnablingPerson = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
        }
        if ([peoplePicker respondsToSelector:@selector(setPredicateForSelectionOfPerson:)]){
            // The people picker will select a person that has exactly one phone number and call peoplePickerNavigationController:didSelectPerson:,
            // otherwise the people picker will present an ABPersonViewController for the user to pick one of the Phone Numbers.
            peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"phoneNumbers.@count = 1"];
        }
        [viewController presentViewController:peoplePicker animated:YES completion:nil];
    }
    return self;
}

#pragma mark - ABPeoplePickerNavigationController Delegate Methods
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if([self.delegate respondsToSelector:@selector(cancelPickerViewController:)]){
        [self.delegate cancelPickerViewController:peoplePicker];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    ABMultiValueRef phoneRecord = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecord, 0);
    NSString *strNumber = (__bridge_transfer NSString *)phoneNumber;
    NSCharacterSet *unwantedChars = [NSCharacterSet characterSetWithCharactersInString:@"-""/()/"" "];
    NSString *requiredString = [[strNumber componentsSeparatedByCharactersInSet:unwantedChars] componentsJoinedByString:@""];
    if([self.delegate respondsToSelector:@selector(didSelectPerson:)]){
        [self.delegate didSelectPerson:requiredString];
    }
    CFRelease(phoneRecord);
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    if (property == kABPersonPhoneProperty) {
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
        CFIndex peopleIndex = ABMultiValueGetIndexForIdentifier(phoneProperty, identifier);
        NSString *strNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneProperty, peopleIndex);
        NSCharacterSet *unwantedChars = [NSCharacterSet characterSetWithCharactersInString:@"-""/()/"" "];
        NSString *requiredString = [[strNumber componentsSeparatedByCharactersInSet:unwantedChars] componentsJoinedByString:@""];
        if([self.delegate respondsToSelector:@selector(didSelectPerson:)]){
            [self.delegate didSelectPerson:requiredString];
        }
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    }
    return NO;
}

@end
