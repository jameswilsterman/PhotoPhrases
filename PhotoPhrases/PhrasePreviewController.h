//
//  PhrasePreviewController.h
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PhrasePreviewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *phraseTextView;
@property (nonatomic,strong) PFObject *selectedObject;
@end
