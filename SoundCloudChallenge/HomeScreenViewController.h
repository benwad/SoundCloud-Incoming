//
//  HomeScreenViewController.h
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth Fixed on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewControllerBase.h"

@interface HomeScreenViewController : ViewControllerBase <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *_ivProfilePic;
    UILabel *_lblUserName;
    UILabel *_lblCity;
    UILabel *_lblNoTracks;
    UITableView *_tblIncomingTracks;
    UIActivityIndicatorView *_aiLoadingTracks;
    
    UIView *_notLoggedInView;
    
    NSMutableArray *_incomingTracks;
    NSURL *_urlGetMoreIncomingTracks;
    NSInteger _trackOffset;
}

@property (nonatomic, retain) IBOutlet UIImageView *ivProfilePic;
@property (nonatomic, retain) IBOutlet UILabel *lblUserName;
@property (nonatomic, retain) IBOutlet UILabel *lblCity;
@property (nonatomic, retain) IBOutlet UILabel *lblNoTracks;
@property (nonatomic, retain) IBOutlet UITableView *tblIncomingTracks;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *aiLoadingTracks;

@property (nonatomic, retain) UIView *notLoggedInView;

@property (nonatomic, retain) NSMutableArray *incomingTracks;
@property (nonatomic, retain) NSURL *urlGetMoreIncomingTracks;
@property (nonatomic, assign) NSInteger trackOffset;

@end
