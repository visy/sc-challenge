//
//  ChapLoginViewController.m
//  ChallengeApp
//
//  Created by visy on 6/21/12.
//

#import "ChapLoginViewController.h"
#import "SCUI.h"
#import "iToast.h"

@interface ChapLoginViewController ()

@end

@implementation ChapLoginViewController

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark Actions
- (IBAction)login:(id)sender 
{
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                completionHandler:^(NSError *error) {
                                    if (SC_CANCELED(error)) {
                                        NSLog(@"SoundCloud login canceled");
                                    } else if (error) {
                                        NSLog(@"SoundCloud login error: %@", [error localizedDescription]);
                                    } else {
                                        NSLog(@"SoundCloud login complete");
                                        [[[[iToast makeText:NSLocalizedString(@"Connected to SoundCloud!", @"")] 
                                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];    

                                    }
                                }
        ];
        
        [self presentModalViewController:loginViewController animated:YES];
    }];
}

- (IBAction)logout:(UIButton *)sender {
    if ([SCSoundCloud account] != nil) {
        [SCSoundCloud removeAccess];
        [[[[iToast makeText:NSLocalizedString(@"Disconnected from SoundCloud", @"")] 
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];    
    } else {
        [[[[iToast makeText:NSLocalizedString(@"Not connected, doing nothing", @"")] 
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];    
    }
}

- (IBAction)showTracks:(UIButton *)sender {
}

@end
