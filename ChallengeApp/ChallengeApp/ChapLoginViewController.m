//
//  ChapLoginViewController.m
//  ChallengeApp
//
//  Created by visy on 6/21/12.
//

#import "ChapLoginViewController.h"
#import "SCUI.h"

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
                                    }
                                }
        ];
        
        [self presentModalViewController:loginViewController animated:YES];
    }];
}

- (IBAction)logout:(UIButton *)sender {
    if ([SCSoundCloud account] != nil) {
        [SCSoundCloud removeAccess];
        
    }
}

- (IBAction)showTracks:(UIButton *)sender {
}

@end
