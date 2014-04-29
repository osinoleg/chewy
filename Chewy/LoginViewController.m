//
//  LoginViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/16/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "LoginViewController.h"
#import "AdminViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController {
    UITextField* _passwordField;
    UITextField* _userNameField;
    
    NSString* _username;
    NSString* _password;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Log In";
    
    int xPadding = 5;
    int yPadding = 5;
    int xOffset = 20;
    int topOffset = self.navigationController.navigationBar.frame.size.height + 50;
    CGSize labelSize = CGSizeMake(100, 24);
    CGSize textFieldSize = CGSizeMake(160, 24);
    
    // Username
    UILabel* userName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, topOffset, labelSize.width, labelSize.height)];
    userName.text = @"User Name:";
    [self.view addSubview:userName];
    
    _userNameField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(xOffset + labelSize.width + xPadding , topOffset,
                                             textFieldSize.width, textFieldSize.height)];
    _userNameField.layer.borderWidth = 1.0f;
    _userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameField.delegate = self;
    [self.view addSubview:_userNameField];
    
    // Password
    UILabel* password = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, topOffset + textFieldSize.height + labelSize.height + yPadding,
                                                                  labelSize.width, labelSize.height)];
    password.text = @"Password:";
    [self.view addSubview:password];
    
    _passwordField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(xOffset + labelSize.width + xPadding ,
                                             topOffset + textFieldSize.height + labelSize.height + yPadding,
                                             textFieldSize.width, textFieldSize.height)];
    _passwordField.layer.borderWidth = 1.0f;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:_passwordField];
    
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(xOffset,
                                     _passwordField.frame.origin.y + _passwordField.frame.size.height + yPadding,
                                     labelSize.width, labelSize.height);
    [submitButton setTitle:@"Log In" forState:UIControlStateNormal];
    submitButton.layer.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    [submitButton addTarget:self action:@selector(validateUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
    UINavigationController* navController = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];

    AdminViewController* controller = [[AdminViewController alloc] initWithUseInfo:_username password:_password];
    [navController pushViewController:controller animated:NO];
    
    _loggedIn = YES;
}

- (void)validateUser
{
    [_passwordField resignFirstResponder];
    [_userNameField resignFirstResponder];
    
    // Validate user
    NSString* fullRequest = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=login&user=%@&password=%@",
                             _username, _password];

    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequest]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
   
    if(error == nil)
    {
        NSError *jsonParsingError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
        
        if (jsonParsingError != nil)
        {
            NSLog(@"Error parsing JSON.");
        }
        else
        {
            NSLog(@"Login result json: %@", jsonResult);
            
            
            BOOL login = NO;
            if([[jsonResult objectForKey:@"result"] isKindOfClass:[NSString class]])
            {
            }
            else if([[jsonResult objectForKey:@"result"] isKindOfClass:[NSNumber class]])
            {
                if([[jsonResult objectForKey:@"result"] isEqualToNumber:[NSNumber numberWithBool:YES]])
                    [self login];
            }
            
            if(login == YES)
                [self login];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _userNameField)
    {
        _username = textField.text;
        appDelegate.username = _username;
    }
    else if(textField == _passwordField)
    {
        _password = textField.text;
        appDelegate.password = _password;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameField) {
        [_passwordField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
