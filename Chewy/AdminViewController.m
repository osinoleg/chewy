//
//  AdminViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/16/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "AdminViewController.h"
#import "AppDelegate.h"

@implementation AdminViewController {
    UITextField* _messageField;
    NSString* _message;
    UILabel* _messageSentStatus;
    NSString* _username;
    NSString* _password;
    UITableView* _messageView;
}

- (id)initWithUseInfo:(NSString*)username password:(NSString*)password
{
    if(self = [super init])
    {
        _password = password;
        _username = username;
        return self;
    }
    
    return self;
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
    CGSize textFieldSize = CGSizeMake(190, 30);
    
    // Username
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, topOffset, labelSize.width, labelSize.height)];
    messageLabel.text = @"Message";
    [self.view addSubview:messageLabel];
    
    _messageField = [[UITextField alloc] initWithFrame:
                      CGRectMake(xOffset + labelSize.width + xPadding , topOffset,
                                 textFieldSize.width, textFieldSize.height)];
    _messageField.layer.borderWidth = 1.0f;
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
    
    CGRect labelFrame = CGRectMake(xOffset, submitButton.frame.size.height + submitButton.frame.origin.y + yPadding,
                                   labelSize.width + 50, labelSize.height);
    
    _messageSentStatus = [[UILabel alloc] initWithFrame:labelFrame];
    _messageSentStatus.text = @"Message Sent Successfully";
    _messageSentStatus.font = [UIFont systemFontOfSize:10];
    _messageSentStatus.hidden = YES;
    [self.view addSubview:_messageSentStatus];
    
    // Populate message stats
    int messageViewY = _messageSentStatus.frame.origin.y + _messageSentStatus.frame.size.height + 5;
    int messageViewHeight = self.view.frame.size.height - messageViewY;
    CGRect messageViweFrame = CGRectMake(0, messageViewY, self.view.frame.size.width, messageViewHeight);

    _messageView = [[UITableView alloc]initWithFrame:messageViweFrame style:UITableViewStylePlain];
    
    _messageView.delegate = self;
    _messageView.dataSource = self;
    
    [_messageView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"messageCell"];
    
    [self.view addSubview:_messageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appDelegate.messages.recentMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // fetch message
    Message* msg = [appDelegate.messages.recentMessages objectAtIndex:indexPath.row];
    NSString* cellTxt = [NSString stringWithFormat:@"%i/%i %@", [msg.sent intValue], [msg.received intValue],  msg.txt];
    cell.textLabel.text = cellTxt;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

# pragma mark NSNotifications

- (void)receiveMessages:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"MessagesChangedNotification"])
    {
        NSLog (@"Got new messages to display");
        [_messageView reloadData];
    }
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
    
    NSString* fullRequest = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=send_push&user=%@&password=%@&message=%@",
                             _username, _password,
                             [_message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequest]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _messageSentStatus.hidden = YES;
}

# pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    NSLog(@"Message sent");
    _messageField.text = @"";
    _messageSentStatus.hidden = NO;
    _messageSentStatus.text = @"Message Sent Successfully";
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
    _messageSentStatus.hidden = NO;
    _messageSentStatus.text = @"Message Failed to send";

}


@end
