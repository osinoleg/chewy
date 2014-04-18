//
//  AdminViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/16/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "AdminViewController.h"

@implementation AdminViewController {
    UITextField* _messageField;
    NSString* _message;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Admin";
    
    int xPadding = 5;
    int yPadding = 5;
    int xOffset = 20;
    int topOffset = self.navigationController.navigationBar.frame.size.height + 50;
    CGSize labelSize = CGSizeMake(100, 24);
    CGSize textFieldSize = CGSizeMake(150, 24);
    
    // Username
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, topOffset, labelSize.width, labelSize.height)];
    messageLabel.text = @"Message";
    [self.view addSubview:messageLabel];
    
    _messageField = [[UITextField alloc] initWithFrame:
                      CGRectMake(xOffset + labelSize.width + xPadding , topOffset,
                                 textFieldSize.width, textFieldSize.height)];
    _messageField.layer.borderWidth = 0.5f;
    _messageField.delegate = self;
    [self.view addSubview:_messageField];
    
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(xOffset,
                                    _messageField.frame.origin.y + _messageField.frame.size.height + yPadding + 10,
                                    labelSize.width, labelSize.height);
    [submitButton setTitle:@"Send" forState:UIControlStateNormal];
    submitButton.layer.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    [submitButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _message = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)send
{
    [_messageField resignFirstResponder];
    NSLog(@"Sending message: %@", _message);
    
    NSString* username = @"chewy";
    NSString* pw = @"chewy";
    
    
    NSString* fullRequest = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=send_push&user=%@&password=%@&message=%@",
                             username, pw,
                             [_message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequest]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    NSLog(@"Message sent");
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
