//
//  PhraseTableViewCell.h
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhraseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phraseTitle;
@property (weak, nonatomic) IBOutlet UILabel *phraseCredit;
@end
