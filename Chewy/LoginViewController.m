//
//  LoginViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/16/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "LoginViewController.h"
#import "AdminViewController.h"

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
    CGSize textFieldSize = CGSizeMake(100, 24);
    
    // Username
    UILabel* userName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, topOffset, labelSize.width, labelSize.height)];
    userName.text = @"User Name:";
    [self.view addSubview:userName];
    
    _userNameField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(xOffset + labelSize.width + xPadding , topOffset,
                                             textFieldSize.width, textFieldSize.height)];
    _userNameField.layer.borderWidth = 0.5f;
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
    _passwordField.layer.borderWidth = 0.5f;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
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

    AdminViewController* controller = [[AdminViewController alloc] init];
    [navController pushViewController:controller animated:NO];
    
    _loggedIn = YES;
}

- (void)validateUser
{
    [_passwordField resignFirstResponder];
    [_userNameField resignFirstResponder];
    
    // Validate user
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _userNameField)
        _username = textField.text;
    else if(textField == _passwordField)
        _password = textField.text;
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

# pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [self login];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // The request has failed for some reason!
    // Check the error var
}

@end
