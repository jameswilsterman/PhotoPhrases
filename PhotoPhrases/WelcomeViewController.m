//
//  WelcomeViewController.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WebViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "AppDelegate.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface WelcomeViewController () {

    NSMutableData *_profilePicData;
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showTerms"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        NSURL *termsURL = [NSURL URLWithString:@"http://www.volleythat.com/the-welcoming-committee/2015/2/9/fraze-terms-of-service"];
        [(WebViewController *)[navController viewControllers][0] setBrowserURL:termsURL];
    }
}

- (IBAction)pressedSignUp:(id)sender {
    NSLog(@"pressedSignUp");
    [self attemptFacebookLogIn];
}

- (void)attemptFacebookLogIn {
    NSLog(@"attemptFacebookLogIn...");
    
    NSArray *permissions = @[@"public_profile",@"user_friends"];
    
    if (![PFUser currentUser]) {
        NSLog(@"no user, signing in");
        [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Error logging in with Facebook %@", error);
            } else if (user) {
                NSLog(@"got user...");
                [self setupFBUser];
            }
        }];
    } else {
        NSLog(@"current user, just linking");
        if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error linking Facebook %@", error);
                }
                
                if (succeeded) {
                    [self setupFBUser];
                }
            }];
        }
    }
    
    /*
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self setupFBUser];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"finishedSignUp" sender:self];
        }
    }];
     */
    
}

- (void)setupFBUser {
    NSLog(@"setupFBUser...");
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *fbError) {
        if (!fbError) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"facebookId"];
            [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                     forKey:@"displayName"];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User logged in through Facebook!");
                    [self performSegueWithIdentifier:@"finishedSignUp" sender:self];
                }
            }];
        }
        
        [self findFacebookFriends]; //takes care of errors itself
    }];
}

- (void)findFacebookFriends {
    
    if (![[PFUser currentUser] objectForKey:@"facebookId"]) {
        [self setupFBUser];
        return;
    }
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSLog(@"friendObjects count: %lu", [friendObjects count]);
            NSMutableArray *friendIds = [NSMutableArray array];
            NSMutableArray *friendNames = [NSMutableArray array];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                NSLog(@"name: %@",[friendObject objectForKey:@"name"]);
                [friendIds addObject:[friendObject objectForKey:@"id"]];
                [friendNames addObject:[friendObject objectForKey:@"name"]];
            }
            
            [[PFUser currentUser] setObject:friendIds
                                     forKey:@"facebookFriends"];
            [[PFUser currentUser] setObject:friendNames
                                     forKey:@"facebookFriendNames"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    // [Crashlytics setUserIdentifier:[PFUser currentUser].objectId];
                    
                    [PFCloud callFunctionInBackground:@"completeFacebook" withParameters:@{} block:^(id object, NSError *error) {
                        if (error) {
                            NSLog(@"Error completing facebook friendships %@", error);
                        } else {
                            NSLog(@"Successfully completed facebook friendships");
                        }
                    }];
                }
                
            }];
        }
        
        [self getProfilePic];
    }];
}

- (void)getProfilePic {
    NSLog(@"getProfilePic");
    
    if (![[PFUser currentUser] objectForKey:@"facebookId"]) {
        [self setupFBUser];
        return;
    }
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:[FBRequest requestWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(500).height(500)"} HTTPMethod:@"GET"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"got pic url...");
            
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSURL *profilePictureURL = [NSURL URLWithString: userData[@"picture"][@"data"][@"url"]];
            
            // Now add the data to the UI elements
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
        } else {
            NSLog(@"Error getting profile pic url, setting as default avatar: %@", error);
            NSData *profilePictureData = UIImagePNGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"]);
            [self processFacebookProfilePictureData:profilePictureData];
        }
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"Failed save in background of user, %@", error);
            } else {
                NSLog(@"saved current parse user");
            }
        }];
    }];
    [connection start];
}

- (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    NSLog(@"Processing profile picture of size: %@", @(newProfilePictureData.length));
    if (newProfilePictureData.length == 0) {
        return;
    }
    
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
    
    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
    
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:@"profilePictureMedium"];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:@"profilePictureSmall"];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
    NSLog(@"Processed profile picture");
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _profilePicData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_profilePicData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self processFacebookProfilePictureData:_profilePicData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection error downloading profile pic data: %@", error);
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
