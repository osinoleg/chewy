//
//  MainViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "MainViewController.h"
#import "ChewyView.h"
#import "Messages.h"
#import "LoginViewController.h"
#import "AdminViewController.h"
#import "AppDelegate.h"

@implementation MessageCell {
    
}

- (void)setMessageText:(NSString *)messageText
{
    self.textLabel.text = messageText;
    _messageText = messageText;
}

@end

@implementation MainViewController {
    ChewyView* _chewyView;
    LoginViewController* _loginController;
    UITableView* _messageView;
    NSMutableData* _responseData;
    Chewy* _chewyAnimModel;
}

- (id)init
{
    if(self = [super init])
    {
        _chewyAnimModel = [[Chewy alloc] init];
//        NSMutableArray* sampleMsgs = [NSMutableArray arrayWithArray:@[@"msg 1", @"msg 2", @"msg 3",
//                                                                      @"msg 1", @"http://google.com", @"msg 3"]];
//        _messages.recentMessages = sampleMsgs;
        
        return self;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int topOffset = 20 + self.navigationController.navigationBar.frame.size.height + 10;
    int chewyHeight = 200 * ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1);
    CGRect chewyViewFrame = CGRectMake(0, topOffset, self.view.frame.size.width, chewyHeight);
    _chewyView = [[ChewyView alloc] initWithData:_chewyAnimModel frame:chewyViewFrame];
    [self.view addSubview:_chewyView];
    
    UIButton* simulatePushNotification = [UIButton buttonWithType:UIButtonTypeSystem];
    [simulatePushNotification setTitle:@"Simulate" forState:UIControlStateNormal];
    [simulatePushNotification addTarget:self action:@selector(simulatePushNotification) forControlEvents:UIControlEventTouchUpInside];
    simulatePushNotification.frame = CGRectMake(10, topOffset + 10, 100, 30);
    simulatePushNotification.layer.borderWidth = 1.0f;
    //[self.view addSubview:simulatePushNotification]; // for debug only
    
    self.navigationItem.title = @"Chewy";
    
    UIBarButtonItem *admin = [[UIBarButtonItem alloc] initWithTitle:@"Admin" style:UIBarButtonItemStylePlain target:self action:@selector(admin)];
    self.navigationItem.rightBarButtonItem = admin;
    

    int messageViewY = _chewyView.frame.origin.y + _chewyView.frame.size.height + 5;
    int messageViewHeight = self.view.frame.size.height - messageViewY;
    CGRect messageViweFrame = CGRectMake(0, messageViewY, self.view.frame.size.width, messageViewHeight);
    _messageView = [[UITableView alloc]initWithFrame:messageViweFrame style:UITableViewStylePlain];
    
    _messageView.delegate = self;
    _messageView.dataSource = self;
    
    [_messageView registerClass:[MessageCell class] forCellReuseIdentifier:@"messageCell"];

    [self.view addSubview:_messageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessages:)
                                                 name:@"MessagesChangedNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)admin
{
    if(_loginController == nil)
        _loginController = [[LoginViewController alloc] init];
    
    if(_loginController.loggedIn)
    {
        AdminViewController* controller = [[AdminViewController alloc] init];
        [self.navigationController pushViewController:controller animated:NO];
    }
    else
    {
        [self.navigationController pushViewController:_loginController animated:NO];
    }
}

# pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appDelegate.messages.recentMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // fetch message
    cell.messageText = [appDelegate.messages.recentMessages objectAtIndex:indexPath.row];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[appDelegate.messages.messageURLs objectAtIndex:indexPath.row] isKindOfClass:[NSURL class]])
    {
        NSURL* url = [appDelegate.messages.messageURLs objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] openURL:url];
    }
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

# pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    UIView* touchedView = [self.view hitTest:locationPoint withEvent:event];
    
    if(touchedView == _chewyView)
    {
        [_chewyAnimModel playAnim:CHEWY_SPIN_ANIM];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
    //NSString *alertValue = [[data valueForKey:@"aps"] valueForKey:@"alert"];
    //NSDictionary* temp = [NSDictionary dictionaryWithObjectsAndKeys:@", nil]
    //[_messages parsePushData:data];
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

- (void)simulatePushNotification
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
