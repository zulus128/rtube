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
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSArray *sorted = [reservations sortedArrayUsingComparator:^(id obj1, id obj2){
                if ([obj1 isKindOfClass:[BookList class]] && [obj2 isKindOfClass:[BookList class]]) {
                    BookList *s1 = obj1;
                    BookList *s2 = obj2;
                    NSDate *date1 = [dateFormat dateFromString:s1.datetime];
                    NSDate *date2 = [dateFormat dateFromString:s2.datetime];
                    return [date2 compare:date1];
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            self.reservations = sorted;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"reservationsViewCell";
    
    ReservationsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ReservationsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BookList* reservation = [self.reservations objectAtIndex:indexPath.row];
    NSArray* name = [reservation.resto componentsSeparatedByString: @"("];
    cell.labelName.text = [NSString stringWithFormat:@" %@ ", name.firstObject];
    if(name.count > 1) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:name];
        [arr removeObjectAtIndex:0];
//        for(int i = 1; i < name.count; i++) {
//            [arr addObject:[name objectAtIndex:i]];
//        }
        NSString *new = [arr componentsJoinedByString:@"("];
        NSString *trimmedString = [new stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        NSLog(@"--- '%@'", reservation.resto);
        cell.labelAddress.text = [trimmedString substringToIndex:trimmedString.length - 1];
    }
    
//    NSLog(@"--- %@ %@", reservation.status_id, reservation.status_name);
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:reservation.datetime];
    

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeStyle:NSDateFormatterShortStyle];
//    [format setDateStyle:NSDateFormatterFullStyle];
    [format setDateFormat:@"EE, dd.MM.yyyy HH:mm"];
    NSString *string = [format stringFromDate:date];
    
    cell.labelDateCount.text = string;
    
//    UIColor *col = [UIColor whiteColor];
    UIColor *color1 = [UIColor whiteColor];
    switch (reservation.status_id.intValue) {
        case 1:
//            col = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
             color1 = [UIColor colorWithRed:(CGFloat)0x00 / 0xff green:(CGFloat)0x00 / 0xff blue:(CGFloat)0x00 / 0xff alpha:(CGFloat)0x00 / 0xff];
            break;
        case 2:
//            col = [UIColor colorWithRed:230.0f/255.0f green:255.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            color1 = [UIColor colorWithRed:(CGFloat)0xcd / 0xff green:(CGFloat)0xd7 / 0xff blue:(CGFloat)0x9d / 0xff alpha:(CGFloat)0xff / 0xff /*32.0 / 255.0*/];
            break;
        case 3:
//            col = [UIColor whiteColor];
            color1 = [UIColor colorWithRed:(CGFloat)0x00 / 0xff green:(CGFloat)0x00 / 0xff blue:(CGFloat)0x00 / 0xff alpha:(CGFloat)0x00 / 0xff];
            break;
        case 4:
//            col = [UIColor colorWithRed:255.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            color1 = [UIColor colorWithRed:(CGFloat)0xe1 / 0xff green:(CGFloat)0x98 / 0xff blue:(CGFloat)0x88 / 0xff alpha:(CGFloat)0xff / 0xff /*32.0 / 255.0*/];
            break;
    }
    
//    cell.contentView.backgroundColor = col;
    
//    [cell.contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    NSInteger i = 0;
    NSMutableArray *toDel = [NSMutableArray array];
    for (CALayer *layer in cell.contentView.layer.sublayers) {
        if([layer isMemberOfClass:[CAGradientLayer class]]) {
            [toDel addObject:layer];
        }
        i++;
    }
    for (CALayer *layer in toDel) {
        [layer removeFromSuperlayer];
    }
    
    UIColor *color2 = [UIColor colorWithRed:(CGFloat)0xff / 0xff green:(CGFloat)0xff / 0xff blue:(CGFloat)0xff / 0xff alpha:0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor], (id)[color2 CGColor], nil];
    [cell.contentView.layer insertSublayer:gradient atIndex:0];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);

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


