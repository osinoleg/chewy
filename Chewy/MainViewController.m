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

@implementation MainViewController {
    ChewyView* _chewyView;
    Messages* _messages;
    LoginViewController* _loginController;
    UITableView* _messageView;
    NSMutableData* _responseData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messages = [[Messages alloc] init];
    NSMutableArray* sampleMsgs = [NSMutableArray arrayWithArray:@[@"msg 1", @"msg 2", @"msg 3"]];
    _messages.recentMessages = sampleMsgs;

    [_messages addObserver:self forKeyPath:@"recentMessages"
                   options:NSKeyValueObservingOptionNew  context:nil];
    
    int topOffset = 20 + self.navigationController.navigationBar.frame.size.height;
    
    //_chewyView = [[ChewyView alloc] initWithData:_messages frame:self.view.frame];
    //[self.view addSubview:_chewyView];
    
    UIButton* simulatePushNotification = [UIButton buttonWithType:UIButtonTypeSystem];
    [simulatePushNotification setTitle:@"Simulate" forState:UIControlStateNormal];
    [simulatePushNotification addTarget:self action:@selector(simulatePushNotification) forControlEvents:UIControlEventTouchUpInside];
    simulatePushNotification.frame = CGRectMake(10, topOffset + 10, 100, 30);
    simulatePushNotification.layer.borderWidth = 1.0f;
    [self.view addSubview:simulatePushNotification];
    
    self.navigationItem.title = @"Chewy";
    
    UIBarButtonItem *admin = [[UIBarButtonItem alloc] initWithTitle:@"Admin" style:UIBarButtonItemStylePlain target:self action:@selector(admin)];
    self.navigationItem.rightBarButtonItem = admin;
    

    int messageViewHeight = 200;
    CGRect messageViweFrame = CGRectMake(0, messageViewHeight + topOffset, self.view.frame.size.width,
                                         self.view.frame.size.height - messageViewHeight - topOffset);
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
    return [_messages.recentMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // fetch message
    cell.textLabel.text = [_messages.recentMessages objectAtIndex:indexPath.row];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

# pragma mark kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"recentMessages"])
    {
        //        NSString* oldC = [change objectForKey:NSKeyValueChangeOldKey];
        NSString* newMessage = [change objectForKey:NSKeyValueChangeNewKey];
        // update _messageViews
        
        [_messageView reloadData];
    }
    

}

# pragma mark connection

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
    
    [_messages parseData:data];
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
