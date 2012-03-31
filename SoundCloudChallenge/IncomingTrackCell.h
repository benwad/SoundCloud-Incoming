//
//  IncomingTrackCell.h
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;

@interface IncomingTrackCell : UITableViewCell
{
//    NSDictionary *_trackDict;
    
    UILabel *_lblTrackName;
    UILabel *_lblArtistName;
    EGOImageView *_ivWaveform;
}

//@property (nonatomic, retain) NSDictionary *trackDict;

@property (nonatomic, retain) IBOutlet UILabel *lblTrackName;
@property (nonatomic, retain) IBOutlet UILabel *lblArtistName;
@property (nonatomic, retain) IBOutlet EGOImageView *ivWaveform;

@end
