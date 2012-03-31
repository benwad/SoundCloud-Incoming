//
//  IncomingTrackCell.m
//  SoundCloudChallenge
//
//  Created by Ben Wadsworth on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IncomingTrackCell.h"

@implementation IncomingTrackCell

@synthesize lblTrackName=_lblTrackName,
            lblArtistName=_lblArtistName,
            ivWaveform=_ivWaveform;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
