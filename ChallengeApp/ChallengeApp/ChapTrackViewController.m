//
//  ChapTrackViewController.m
//  ChallengeApp
//
//  Created by visy on 6/21/12.
//

#import "ChapTrackViewController.h"
#import "ChapTrack.h"

@interface ChapTrackViewController ()

@end

@implementation ChapTrackViewController

@synthesize tracks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tracks = [NSMutableArray arrayWithCapacity:100];
    ChapTrack *track = [[ChapTrack alloc] init];
    
    track.title = @"Enjoy the silence";
    track.date = @"1-1-1991";
    [tracks addObject:track];
    track = [[ChapTrack alloc] init];
    
    track.title = @"Personal Jesus";
    track.date = @"15-12-2000";
    [tracks addObject:track];
    track = [[ChapTrack alloc] init];
    
    track.title = @"Let the bodies hit the floor";
    track.date = @"9-9-1995";
    [tracks addObject:track];
    track = [[ChapTrack alloc] init];
    
    track.title = @"French God";
    track.date = @"2-4-1899";
    [tracks addObject:track];

    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
	ChapTrack *track = [self.tracks objectAtIndex:indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = track.date;
    
    // TODO: add waveform for each track image here
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    return cell;
}

@end
