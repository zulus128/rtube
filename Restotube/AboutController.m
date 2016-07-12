//
//  AboutController.m
//  Restotube
//
//  Created by VADIM KASSIN on 7/8/16.
//  Copyright © 2016 Maksim Kis. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"О приложении"];
}

- (IBAction)feedbackClicked:(id)sender {
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@restotube.ru"]];
}

@end
