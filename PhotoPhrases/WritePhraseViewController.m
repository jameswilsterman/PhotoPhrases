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
@property (weak, nonatomic) IBOutlet UITextField *phraseTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendPhraseButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WritePhraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
    [self.sendPhraseButton setEnabled:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatePhrase:(UIButton *)sender {
    NSLog(@"generatePhrase");
    [PFCloud callFunctionInBackground:@"randomPhrase"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        
                                        self.phraseTextField.text = result;
                                    }
                                }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.phraseTextField.text.length > 0){
        [self.phraseTextField resignFirstResponder];
        [self pressSend:nil];
        return YES;
    }
    
    return NO;
}

- (IBAction)pressSend:(id)sender{
    
    if (self.phraseTextField.text.length > 0){// Only do something if we have some text to send
        [self.phraseTextField resignFirstResponder];
   
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
        
            // do stuff with the user
            PFObject *chainActivity;
            if (self.selectedObject){
                chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
                chainActivity[@"partOfChain"] = [self.selectedObject objectForKey:@"partOfChain"];
                chainActivity[@"phraseText"] = self.phraseTextField.text;
                chainActivity[@"fromPFUser"] = currentUser;
                chainActivity[@"linkIndex"] =  [NSNumber numberWithInteger:[[self.selectedObject objectForKey:@"linkIndex"] integerValue] + 1];
                chainActivity[@"responded"] = @NO;
            
            }else {
                chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
                chainActivity[@"phraseText"] =  self.phraseTextField.text;
                chainActivity[@"fromPFUser"] = currentUser;
                chainActivity[@"linkIndex"] = @0;
                chainActivity[@"responded"] = @NO;
            }
            [self.sendPhraseButton setEnabled:NO];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            [chainActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.activityIndicator stopAnimating];
                    [self.activityIndicator setHidden:YES];
                } else {
                    // There was a problem, check error.description
                }
            }];
        
        } else {
            // show the signup or login screen?
        }
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
