//
//  ReservationsViewController.m
//  Restotube
//
//  Created by Maksim Kis on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReservationsViewController.h"
#import "ReservationsViewCell.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "RequestManager.h"
#import "BookList.h"
#import "ReservationInfoViewController.h"

@interface ReservationsViewController()
@property (readwrite, nonatomic, strong) NSArray *reservations;
@end

@implementation ReservationsViewController

- (void)reload:(__unused id)sender {
    NSURLSessionTask *task = [BookList reservationsWithBlock: ^(NSArray *reservations, NSError *error) {
        if (!error) {
            self.reservations = reservations;
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

-(void) viewDidLoad {
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
     self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.navigationBar setTranslucent:false];


    [self.tableView setAllowsSelection:YES];
    [self.navigationItem setTitle:@"Брони"];
//    [self reload:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self reload:nil];
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return (NSInteger)[self.reservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"reservationsViewCell";
    
    ReservationsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ReservationsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BookList* reservation = [self.reservations objectAtIndex:indexPath.row];
    cell.labelName.text = reservation.resto;
    
//    NSLog(@"--- %@ %@", reservation.status_id, reservation.status_name);
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:reservation.datetime];
    

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateStyle:NSDateFormatterFullStyle];
    NSString *string = [format stringFromDate:date];
    
    cell.labelDateCount.text = string;
    
    UIColor *col = [UIColor whiteColor];
    switch (reservation.status_id.intValue) {
        case 1:
            col = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            break;
        case 2:
            col = [UIColor colorWithRed:230.0f/255.0f green:255.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            break;
        case 3:
            col = [UIColor whiteColor];
            break;
        case 4:
            col = [UIColor colorWithRed:255.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            break;
    }
    
    cell.contentView.backgroundColor = col;
    
//    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?
//                                            [UIColor whiteColor] :
//                                            [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookList* book = [self.reservations objectAtIndex:(NSUInteger)indexPath.row];
    [self performSegueWithIdentifier:@"ReservationInfoSegue" sender:book];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReservationInfoSegue"]) {
        ReservationInfoViewController *controller = (ReservationInfoViewController *)segue.destinationViewController;
        Reservation* reservation = [[Reservation alloc] init];
        BookList* book = (BookList *)sender;
        reservation.address = book.address;
        reservation.book_id = book.book_Id;
        reservation.col = book.amount;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:book.datetime];
        NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
        formatDate.dateFormat = @"dd MMMM yyyy";
        NSString* date_string = [formatDate stringFromDate:date];
        
        NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
        formatTime.dateFormat = @"HH:mm";
        NSString *time_string = [formatTime stringFromDate:date];
        
        reservation.date = date_string;
        reservation.time = time_string;
        reservation.sale = book.sale;
        reservation.resto = book.resto;
        reservation.reservation_id = book.book_Id;
        controller.reservation = reservation;
        controller.nameString = [NSString stringWithFormat:@"%@", book.name];
    }
}
@end


