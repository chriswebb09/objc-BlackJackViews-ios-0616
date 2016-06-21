//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseStayedLabel;

@property (weak, nonatomic) IBOutlet UILabel *houseCard1Label;
@property (weak, nonatomic) IBOutlet UILabel *houseCard2Label;
@property (weak, nonatomic) IBOutlet UILabel *houseCard3Label;
@property (weak, nonatomic) IBOutlet UILabel *houseCard4Label;
@property (weak, nonatomic) IBOutlet UILabel *houseCard5Label;
@property (weak, nonatomic) IBOutlet UILabel *houseBustLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseBlackjackLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLossesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerStayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCard1Label;
@property (weak, nonatomic) IBOutlet UILabel *playerCard2Label;
@property (weak, nonatomic) IBOutlet UILabel *playerCard3Label;
@property (weak, nonatomic) IBOutlet UILabel *playerCard4Label;
@property (weak, nonatomic) IBOutlet UILabel *playerCard5Label;

@property (weak, nonatomic) IBOutlet UILabel *playerBust;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *playerWins;

@property (weak, nonatomic) IBOutlet UILabel *playerLosses;
@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)dealButtonTapped:(id)sender {
}



- (IBAction)hitButtonTapped:(id)sender {
}


- (IBAction)stayButtonTapped:(id)sender {
}

@end
