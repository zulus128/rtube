//
//  FirstViewController.m
//  Restotube
//
//  Created by owel on 30/08/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "FirstViewController.h"
#import "IntroViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IntroViewController * destViewController = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    [self presentViewController:destViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self performSegueWithIdentifier:@"introViewController" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
