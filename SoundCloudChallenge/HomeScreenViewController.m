//
//  HomeScreenViewController.m
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth Fixed on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"

#import "IncomingTrackCell.h"
#import "EGOImageView.h"

#import "SCUI.h"
#import "SCLoginViewController.h"
#import "JSONKit.h"

@interface HomeScreenViewController ()

- (void)scLogin;
- (void)scLogout;
- (void)scGetUserDetails;
- (void)scGetIncomingTracks;
- (void)scGetMoreIncomingTracks;
- (void)loadProfilePicWithURL:(NSURL *)picUrl;
- (void)displayProfilePic:(UIImage *)image;
- (void)getTrackDataFromArray:(NSArray *)array;
- (void)presentTable;
- (void)presentNoTracksLabel;

@end

@implementation HomeScreenViewController

@synthesize ivProfilePic=_ivProfilePic,
            lblUserName=_lblUserName,
            lblCity=_lblCity,
            lblNoTracks=_lblNoTracks,
            tblIncomingTracks=_tblIncomingTracks,
            incomingTracks=_incomingTracks,
            aiLoadingTracks=_aiLoadingTracks,
            urlGetMoreIncomingTracks=_urlGetMoreIncomingTracks,
            trackOffset=_trackOffset;

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
    
    self.tblIncomingTracks.delegate = self;
    self.tblIncomingTracks.dataSource = self;
    
    self.tblIncomingTracks.hidden = YES;
    self.urlGetMoreIncomingTracks = nil;
    
    self.trackOffset = 0;
    self.incomingTracks = [NSMutableArray arrayWithCapacity:20];
    
    [self scLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tblIncomingTracks deselectRowAtIndexPath:self.tblIncomingTracks.indexPathForSelectedRow animated:YES];
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

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IncomingTrackCell";
    static NSString *loadMoreCellIdentifier = @"LoadMoreCell";
    
    if (indexPath.row < [self.incomingTracks count])
    {
        IncomingTrackCell *cell = (IncomingTrackCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IncomingTrackCell"
                                                                     owner:nil options:nil];
            
            for (id currentObject in topLevelObjects)
            {
                if ([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (IncomingTrackCell *)currentObject;
                    break;
                }
            }
        }
        
        NSDictionary *trackData = [self.incomingTracks objectAtIndex:indexPath.row];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
        
        cell.ivWaveform.imageURL = [NSURL URLWithString:[trackData objectForKey:@"waveform_url"]];
        
        cell.lblTrackName.text = [trackData objectForKey:@"title"];
        cell.lblArtistName.text = [[trackData objectForKey:@"user"] objectForKey:@"username"];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadMoreCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 48.0)];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
        
        UILabel *lblClickToLoad = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        lblClickToLoad.textAlignment = UITextAlignmentCenter;
        lblClickToLoad.text = @"Click to load more";
        lblClickToLoad.tag = 50;
        
        UIActivityIndicatorView *aiLoadingMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiLoadingMore.frame = CGRectMake((cell.frame.size.width / 2.0) - (aiLoadingMore.frame.size.width / 2.0),
                                         (cell.frame.size.height / 2.0) - (aiLoadingMore.frame.size.height / 2.0),
                                         aiLoadingMore.frame.size.width, aiLoadingMore.frame.size.height);
        aiLoadingMore.tag = 51;
        aiLoadingMore.hidesWhenStopped = YES;
        [aiLoadingMore stopAnimating];
        
        [cell addSubview:lblClickToLoad];
        [cell addSubview:aiLoadingMore];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.incomingTracks count])
    {
        // @todo: bring up the track in SoundCloud app or browser
        NSLog(@"Track data: %@", [[self.incomingTracks objectAtIndex:indexPath.row] description]);
        
        NSURL *trackURL = [NSURL URLWithString:[[self.incomingTracks objectAtIndex:indexPath.row] objectForKey:@"permalink_url"]];
        [[UIApplication sharedApplication] openURL:trackURL];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:50].hidden = YES;
        [(UIActivityIndicatorView *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:51] startAnimating];
        if (self.urlGetMoreIncomingTracks != nil)
        {
            [self scGetMoreIncomingTracks];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.incomingTracks count]+1;
    else {
        return 0;
    }
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
                                                                              self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(scLogout)                                                                                       ];
                                                                              [self scGetUserDetails];
                                                                          }
                                                                      }];
        
        [self presentModalViewController:loginViewController
                                animated:YES];
        
    }];
}

- (void)scLogout
{
    [SCSoundCloud removeAccess];
    [self scLogin];
}

- (void)scGetUserDetails
{
    [self.aiLoadingTracks startAnimating];
    
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
                              NSLog(@"String data: %@", strData);
                              NSDictionary *dictData = [strData objectFromJSONString];
                              self.lblUserName.text = [dictData objectForKey:@"username"];
                              self.lblCity.text = [dictData objectForKey:@"city"];
                              
                              NSOperationQueue *queue = [NSOperationQueue new];
                              NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                                  initWithTarget:self
                                                                  selector:@selector(loadProfilePicWithURL:)
                                                                  object:[NSURL URLWithString:[dictData objectForKey:@"avatar_url"]]];
                              [queue addOperation:operation];
                              [self scGetIncomingTracks];
                          }
                      }];
}

- (void)scGetIncomingTracks
{
    SCAccount *account = [SCSoundCloud account];
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/activities/tracks/affiliated.json?limit=20"]
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
                              NSArray *incomingArray = [dictData objectForKey:@"collection"];
                              
                              if ([dictData objectForKey:@"next_href"] != nil)
                              {
                                  self.urlGetMoreIncomingTracks = [NSURL URLWithString:[[dictData objectForKey:@"next_href"] stringByReplacingOccurrencesOfString:@"affiliated?" withString:@"affiliated.json?"]];
                              }
                              
                              [self getTrackDataFromArray:incomingArray];
                              [self.tblIncomingTracks reloadData];
                              [self.aiLoadingTracks stopAnimating];
                              self.trackOffset = 20;
                              
                              if ([self.incomingTracks count] > 0)
                              {
                                  [self presentTable];
                              }
                              else {
                                  [self presentNoTracksLabel];
                              }
                          }
                      }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)scGetMoreIncomingTracks
{
    SCAccount *account = [SCSoundCloud account];
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:self.urlGetMoreIncomingTracks
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
                              NSLog(@"String data: %@", strData);
                              NSDictionary *dictData = [strData objectFromJSONString];
                              NSArray *incomingArray = [dictData objectForKey:@"collection"];
                              if ([dictData objectForKey:@"next_href"] != nil)
                              {
                                  self.urlGetMoreIncomingTracks = [NSURL URLWithString:[[dictData objectForKey:@"next_href"] stringByReplacingOccurrencesOfString:@"/affiliated?" withString:@"/affiliated.json?"]];
                              }
                              [self getTrackDataFromArray:incomingArray];
                              [self.tblIncomingTracks reloadData];
                              
                              self.trackOffset += 20;
                          }
                      }];
}

- (void)loadProfilePicWithURL:(NSURL *)picUrl
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:picUrl];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self performSelectorOnMainThread:@selector(displayProfilePic:) withObject:image waitUntilDone:NO];
}

- (void)displayProfilePic:(UIImage *)image
{
    self.ivProfilePic.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [self.ivProfilePic setImage:image];
}

- (void)presentTable
{
    self.lblNoTracks.hidden = YES;
    self.tblIncomingTracks.alpha = 0.0;
    self.tblIncomingTracks.hidden = NO;
    [UIView beginAnimations:@"FadeInTable" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    self.tblIncomingTracks.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)presentNoTracksLabel
{
    self.tblIncomingTracks.hidden = YES;
    self.lblNoTracks.alpha = 0.0;
    self.lblNoTracks.hidden = NO;
    [UIView beginAnimations:@"FadeInNoTracksLabel" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    self.lblNoTracks.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)getTrackDataFromArray:(NSArray *)array
{
    for (NSDictionary *incoming in array)
    {
        if ([[incoming objectForKey:@"type"] isEqualToString:@"track"])
        {
            NSDictionary *trackData = [incoming objectForKey:@"origin"];
            [self.incomingTracks addObject:trackData];
        }
    }
}

@end
