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
                              
                              NSDictionary *tracks = [dataDict objectForKey:@"tracks"];
                                                            
                              for (NSDictionary *tmpDict in tracks) {
                                  NSString *track_id = [tmpDict objectForKey:@"id"];
                                  NSString *track_title = [tmpDict objectForKey:@"title"];
                                  NSString *track_date = [tmpDict objectForKey:@"created_at"];
                                  NSString *track_waveform_url = [tmpDict objectForKey:@"waveform_url"];
                                  
                                  ChapTrack *track = [[ChapTrack alloc] init];
                                  
                                  track.id = track_id;
                                  track.title = track_title;
                                  track.date = track_date;
                                  
                                  NSString *waveform_url = track_waveform_url;
                                  
                                  NSURL *url = [NSURL URLWithString: waveform_url];
                                  UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
                                  
                                  track.waveform_image = image;
                                  
                                  [self.tracks addObject:track];
                              }
                              
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
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight) return NO;
    else return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    
    // Create UIImageView with Image
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([track.waveform_image CGImage], CGRectMake(0, 0, track.waveform_image.size.width, track.waveform_image.size.height/2));
    
    UIImage *backgroundImage = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
        
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:cell.frame];
    [myImageView setImage:[backgroundImage stretchableImageWithLeftCapWidth:3 topCapHeight:3]]; 
    [myImageView setUserInteractionEnabled:YES];
        
    cell.backgroundView = myImageView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	ChapTrack *track = [self.tracks objectAtIndex:indexPath.row];
    
    NSString *track_url = [NSString stringWithFormat:@"soundcloud:track:%@", track.id];
    NSLog(@"url: '%@'", track_url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: track_url]];
}

@end
