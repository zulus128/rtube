//
//  FilterButtonsViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterButtonsViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton   *buttonAction;
@property (nonatomic, weak) IBOutlet UIView     *buttonContainer;

- (IBAction)    buttonAction:(id)sender forEvent:(UIEvent *)event;
- (void)        reset;
@end
