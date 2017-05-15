//
//  ContactPickerView.h
//  DemoContacts
//
//  Created by Bhavin Gupta on 09/01/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol ContactPickerDelegate <NSObject>

@required
- (void)didSelectPerson:(NSString *)strPhoneNumber;

@optional
- (void)cancelPickerViewController:(ABPeoplePickerNavigationController *)peoplePicker;

@end

@interface ContactPickerView : NSObject<ABPeoplePickerNavigationControllerDelegate>

- (id)initWithViewController:(UIViewController *)viewController;

@property (weak, nonatomic) id<ContactPickerDelegate> delegate;

@end
