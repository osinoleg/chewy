//
//  AppDelegate.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NavigationViewController.h"

#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate {
    MainViewController* _mainViewController;
    NSString* _deviceToken;
    AVAudioPlayer* _audioPlayer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _messages = [[Messages alloc] init];
    
    _mainViewController = [[MainViewController alloc] init];
    UINavigationController* navController = [[NavigationViewController alloc] initWithRootViewController:_mainViewController];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    if(launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self addMessageFromRemoteNotification:dictionary];
		}
	}
    
    
    // Request all messages from server
    NSString* fullRequestURL = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=get_message_history"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequestURL]];
    
    // Create url connection and fire request
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/pushnote.wav", [[NSBundle mainBundle] resourcePath]]];
	NSError *error;
	_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	_audioPlayer.numberOfLoops = 0;

    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
    if(jsonParsingError == nil)
        [_messages parseServerData:jsonResult];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
	[self addMessageFromRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo
{
    NSInteger msgId = [_messages parsePushData:userInfo];
    
    // Tell the server that we actually got this msg (for analytics)
    //action=recieved_message&device_id=WHATEVER&message_id=3
    NSString* fullRequestURL = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=recieved_message&device_id=%@&message_id=%i",
                                _deviceToken, msgId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequestURL]];
    
    // Create url connection and fire request
    [[NSURLConnection alloc] initWithRequest:request delegate:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;   
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
    NSString* fullRequestURL = [NSString stringWithFormat:@"http://54.186.181.133/chewy.php?action=register_device&device_id=%@", token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullRequestURL]];
    
    // Create url connection and fire request
    [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    
    _deviceToken = token;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
