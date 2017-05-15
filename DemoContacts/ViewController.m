//
//  ViewController.m
//  DemoContacts
//
//  Created by Bhavin Gupta on 09/01/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "ViewController.h"
#import "ContactPickerView.h"

@interface ViewController ()<UITextFieldDelegate,ContactPickerDelegate>{
    IBOutlet UITextField *phoneField;
}

@property (strong, nonatomic) ContactPickerView *contactPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(IBAction)onClickOpenContacts:(id)sender{
    self.contactPickerView = [[ContactPickerView alloc]initWithViewController:self];
    self.contactPickerView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)didSelectPerson:(NSString *)strPhoneNumber{
    phoneField.text = strPhoneNumber;
}

@end
