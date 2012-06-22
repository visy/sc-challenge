//
//  ChapTrackViewController.m
//  ChallengeApp
//
//  Created by visy on 6/21/12.
//

#import "ChapTrackViewController.h"
#import "ChapTrack.h"

#import "SCUI.h"
#import "iToast.h"
#import "JSONKit.h"

@interface ChapTrackViewController ()

@end

@implementation ChapTrackViewController

@synthesize tracks;

- (IBAction)refreshTracks:(id)sender 
{
    SCAccount *account = [SCSoundCloud account];
    
    id obj = [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:@"https://api.soundcloud.com/playlists/405726.json"]
                      usingParameters:nil
                          withAccount:account
               sendingProgressHandler:nil
                      responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                          // Handle the response
                          if (error) {
                              NSLog(@"SoundCloud request error: %@", [error localizedDescription]);
                              [self.tracks removeAllObjects];
                              [self.tableView reloadData];
                              [[[[iToast makeText:NSLocalizedString(@"SoundCloud request failed!\nCheck connection and login.", @"")] 
                                 setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];    
                          } else {
                              NSLog(@"SoundCloud request complete.");
                              [self.tracks removeAllObjects];
                              
                              NSDictionary *dataDict = [data objectFromJSONData];
                              
                              NSLog(@"%@", [dataDict description]);
                              /*
                              ChapTrack *track = [[ChapTrack alloc] init];
                              track.title = @"SUCCESS: here's some parsed tracks";
                              track.date = @"";
                              [self.tracks addObject:track];
                               */
                              
                              [self.tableView reloadData];

                          }
                      }
              ];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tracks = [NSMutableArray arrayWithCapacity:100];
    ChapTrack *track = [[ChapTrack alloc] init];
    track.title = @"Press refresh!";
    [tracks addObject:track];

    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tracks removeAllObjects];
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
    int cc = [self.tracks count];
	return cc;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
	ChapTrack *track = [self.tracks objectAtIndex:indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = track.date;
    
    // TODO: add waveform for each track image here
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.45 green:0.25 blue:0.25 alpha:1];
    cell.backgroundView = myBackView;
    
    return cell;
}

@end
