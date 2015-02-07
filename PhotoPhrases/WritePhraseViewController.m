//
//  WritePhraseViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WritePhraseViewController.h"
#import <Parse/Parse.h>

@interface WritePhraseViewController ()

@property (nonatomic) NSString *phraseText;

@end

@implementation WritePhraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didEndOnExit:(UITextField *)sender {
    NSLog(@"valueChanged");
    self.phraseText = sender.text;
    [self pressSend];
}


- (IBAction)valueChanged:(UITextField *)sender {
    NSLog(@"valueChanged");
    self.phraseText = sender.text;
}

#warning should show login screen if no user here
- (IBAction)pressSend {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        
        PFObject *chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
        chainActivity[@"phraseText"] = self.phraseText;
        chainActivity[@"fromPFUser"] = currentUser;
        chainActivity[@"linkIndex"] = @0;
        chainActivity[@"responded"] = @NO;
        [chainActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
        
    } else {
        // show the signup or login screen?
    }
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
