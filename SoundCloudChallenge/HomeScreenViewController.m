//
//  HomeScreenViewController.m
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth Fixed on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"

#import "SCUI.h"
#import "SCLoginViewController.h"
#import "JSONKit.h"

@interface HomeScreenViewController ()

- (void)scLogin;
- (void)scGetUserDetails;
- (void)loadProfilePicWithURL:(NSURL *)picUrl;
- (void)displayProfilePic:(UIImage *)image;

@end

@implementation HomeScreenViewController

@synthesize ivProfilePic=_ivProfilePic,
            lblUserName=_lblUserName,
            tblIncomingTracks=_tblIncomingTracks;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self scLogin];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)scLogin
{
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                          } else {
                                                                              NSLog(@"Done!");
                                                                              NSLog(@"Account id: %@", [SCSoundCloud account].identifier);
                                                                              [self scGetUserDetails];
                                                                          }
                                                                      }];
        
        [self presentModalViewController:loginViewController
                                animated:YES];
        
    }];
}

- (void)scGetUserDetails
{
    SCAccount *account = [SCSoundCloud account];
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]
                      usingParameters:nil
                          withAccount:account
               sendingProgressHandler:nil
                      responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                          // Handle the response
                          if (error) {
                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                          } else {
                              // Check the statuscode and parse the data
                              NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                              NSDictionary *dictData = [strData objectFromJSONString];
                              self.lblUserName.text = [dictData objectForKey:@"username"];
                          }
                      }];
}

- (void)loadProfilePicWithURL:(NSURL *)picUrl
{
    
}

- (void)displayProfilePic:(UIImage *)image
{

}

@end
