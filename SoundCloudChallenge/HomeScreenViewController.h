//
//  HomeScreenViewController.h
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth Fixed on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UIViewController
{
    UIImageView *_ivProfilePic;
    UILabel *_lblUserName;
    UITableView *_tblIncomingTracks;
}

@property (nonatomic, retain) IBOutlet UIImageView *ivProfilePic;
@property (nonatomic, retain) IBOutlet UILabel *lblUserName;
@property (nonatomic, retain) IBOutlet UITableView *tblIncomingTracks;

@end
