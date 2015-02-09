//
//  WritePhraseViewController.h
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WritePhraseViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) PFObject *selectedObject;
@property (nonatomic) BOOL showInstructions;
@end
