//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 7/3/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *winner;
@property (weak, nonatomic) IBOutlet UIButton *deal;
@property (weak, nonatomic) IBOutlet UIButton *hit;
@property (weak, nonatomic) IBOutlet UIButton *stay;
@property (weak, nonatomic) IBOutlet UILabel *houseScore;
@property (weak, nonatomic) IBOutlet UILabel *houseStayed;
@property (weak, nonatomic) IBOutlet UILabel *houseBust;
@property (weak, nonatomic) IBOutlet UILabel *houseBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *houseWins;
@property (weak, nonatomic) IBOutlet UILabel *houseLosses;
@property (weak, nonatomic) IBOutlet UILabel *playerScore;
@property (weak, nonatomic) IBOutlet UILabel *playerStayed;
@property (weak, nonatomic) IBOutlet UILabel *playerBust;
//@property (weak, nonatomic) IBOutlet UILabel *playerBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *playerWins;
@property (weak, nonatomic) IBOutlet UILabel *playerLosses;
@property (weak, nonatomic) IBOutlet UILabel *house;
@property (weak, nonatomic) IBOutlet UILabel *player;
@property (weak, nonatomic) IBOutlet UILabel *playerCard1;
@property (weak, nonatomic) IBOutlet UILabel *playerCard2;
@property (weak, nonatomic) IBOutlet UILabel *playerCard3;
@property (weak, nonatomic) IBOutlet UILabel *playerCard4;
@property (weak, nonatomic) IBOutlet UILabel *playerCard5;
@property (weak, nonatomic) IBOutlet UILabel *houseCard1;
@property (weak, nonatomic) IBOutlet UILabel *houseCard2;
@property (weak, nonatomic) IBOutlet UILabel *houseCard3;
@property (weak, nonatomic) IBOutlet UILabel *houseCard4;
@property (weak, nonatomic) IBOutlet UILabel *houseCard5;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjack;

- (void)updateViews;
- (void)newGame;
- (BOOL)playerMayHit;
- (void)playerTurn;
- (void)finishHouseTurn;
- (void)displayHouseScore;
- (void)displayWinner;
- (void)updatePlayerCardLabels;
- (void)displayPlayerHand;
- (void)showActiveStatusLabels;
- (void)displayHouseScore;
- (void)houseTurn;
- (BOOL)houseMayHit;

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseCardViews = @[self.houseCard1, self.houseCard2, self.houseCard3, self.houseCard4, self.houseCard5];
    self.playerCardViews = @[self.playerCard1, self.playerCard2, self.playerCard3, self.playerCard4, self.playerCard5];
    self.game = [[FISBlackjackGame alloc]init];
    [self newGame];
    self.deal.enabled = YES;
    self.hit.enabled = NO;
    self.stay.enabled = NO;
    self.winner.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViews {
    [self updatePlayerCardLabels];
    [self updateHouseCardLabels];
    [self displayPlayerScore];
    [self showActiveStatusLabels];

}


-(void)newGame {
    self.playerCard1.hidden = YES;
    self.playerCard2.hidden = YES;
    self.playerCard3.hidden = YES;
    self.playerCard4.hidden = YES;
    self.playerCard5.hidden = YES;
    
    
    self.houseCard1.hidden = YES;
    self.houseCard2.hidden = YES;
    self.houseCard3.hidden = YES;
    self.houseCard4.hidden = YES;
    self.houseCard5.hidden = YES;
    
    
    self.winner.hidden = YES;
    self.playerBust.hidden = YES;
    self.houseScore.hidden = YES;
    self.houseBust.hidden = YES;
    self.houseStayed.hidden = YES;
    self.playerStayed.hidden = YES;
    self.deal.enabled = NO;
    self.hit.enabled = YES;
    self.stay.enabled = YES;
    self.playerBlackjack.hidden = YES;
    self.houseBlackjack.hidden = YES;
    [self.game.deck shuffleRemainingCards];
}

- (void)finishHouseTurn {
    [self showActiveStatusLabels];
    [self displayWinner];
    [self newGame];
}

- (BOOL)playerMayHit {
    BOOL playerMayHit = !self.game.player.busted && !self.game.player.stayed && !self.game.player.blackjack;
    return playerMayHit;
}


- (BOOL)houseMayHit {
    BOOL houseMayHit = !self.game.house.busted && !self.game.house.stayed && !self.game.house.blackjack;
    return houseMayHit;
}

- (void)playerTurn {
    [self updateViews];
    if (self.game.player.busted)  {
        self.winner.text = @"You lose!";
        self.winner.hidden = NO;
        [self.game incrementWinsAndLossesForHouseWins:YES];
        [self updateWinsAndLossesLabels];
        self.hit.enabled = NO;
        self.stay.enabled = NO;
        self.deal.enabled = YES;
    }
//    if (self.game.player.handscore == 21) {
//        self.playerBlackjack.enabled = YES;
//        self.winner.enabled = YES;
//        self.winner.text = @"You won!";
//    } else if(self.game.player.handscore > 21) {
//        [self showActiveStatusLabels];
//        self.winner.enabled = YES;
//        self.winner.text = @"You lost!";
//        //self.winner.text = @"You won!";
//    }
//    
}

- (void)displayWinner {
    BOOL houseWins = [self.game houseWins];
    if (houseWins) {
        [self.game incrementWinsAndLossesForHouseWins:houseWins];
        self.winner.text = @"House wins!";
        self.winner.hidden = NO;
    } else if (!houseWins) {
        [self.game incrementWinsAndLossesForHouseWins:houseWins];
        self.winner.text = @"Player wins!";
        self.winner.hidden = NO;
    }
    [self updateWinsAndLossesLabels];
}


-(void)updatePlayerCardLabels {
    
    FISCard *playerCard1 = self.game.player.cardsInHand[0];
    FISCard *playerCard2 = self.game.player.cardsInHand[1];
    
    UILabel *cardLabel1 = self.playerCardViews[0];
    UILabel *cardLabel2 = self.playerCardViews[1];
    
    cardLabel1.text = playerCard1.cardLabel;
    cardLabel2.text = playerCard2.cardLabel;
    
    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
        FISCard *displayCard  = self.game.player.cardsInHand[i];
        UILabel *displayCardLabel = self.playerCardViews[i];
        displayCardLabel.hidden = FALSE;
        displayCardLabel.text = displayCard.cardLabel;
    }
}


-(void)updateHouseCardLabels {
    
    FISCard *houseCard1 = self.game.house.cardsInHand[0];
    FISCard *houseCard2 = self.game.house.cardsInHand[1];
    
    UILabel *cardLabel1 = self.houseCardViews[0];
    UILabel *cardLabel2 = self.houseCardViews[1];
    
    cardLabel1.text = houseCard1.cardLabel;
    cardLabel2.text = houseCard2.cardLabel;
    
    for (NSUInteger i = 0; i < self.game.house.cardsInHand.count; i++) {
        FISCard *displayCard  = self.game.house.cardsInHand[i];
        UILabel *displayCardLabel = self.houseCardViews[i];
        displayCardLabel.hidden = FALSE;
        displayCardLabel.text = displayCard.cardLabel;
    }
}


- (void)displayPlayerHand {
    
}

- (void)showActiveStatusLabels {
    self.houseStayed.hidden = !self.game.house.stayed;
    self.houseBust.hidden = !self.game.house.busted;
    self.houseBlackjack.hidden = !self.game.house.blackjack;
    
    self.playerStayed.hidden = !self.game.player.stayed;
    self.playerBust.hidden = !self.game.player.busted;
    self.playerBlackjack.hidden = !self.game.player.blackjack;
}


-(void)updateWinsAndLossesLabels {
    self.houseWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
    self.houseLosses.text = [NSString stringWithFormat:@"Losses %lu", self.game.house.losses];
    self.playerWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
    self.playerLosses.text = [NSString stringWithFormat:@"Losses %lu", self.game.player.losses];
}


- (void)displayHouseScore {
    NSUInteger houseScore = self.game.house.handscore;
    self.houseScore.text = [NSString stringWithFormat:@"Score: %lu", houseScore];
    self.houseScore.hidden = NO;
}


- (void)displayPlayerScore {
    NSUInteger playerScore = self.game.player.handscore;
    self.playerScore.text = [NSString stringWithFormat:@"Score: %lu", playerScore];
    self.playerScore.hidden = NO;
}

- (void)houseTurn {
    if ([self houseMayHit]) {
        [self.game dealCardToHouse];
        [self updateHouseCardLabels];
        [self displayHouseScore];
    }
    [self displayWinner];
}


- (IBAction)dealButtonTapped:(id)sender {
    [self newGame];
    [self.game dealNewRound];
    [self updateViews];
    self.houseCard1.hidden = NO;
    self.houseCard2.hidden = NO;
}

- (IBAction)hitButtonTapped:(id)sender {
    [self.game dealCardToPlayer];
    [self updateViews];
}

- (IBAction)stayButtonTapped:(id)sender {
    self.hit.enabled = NO;
    self.stay.enabled = NO;
    self.playerStayed.hidden = NO;
    [self houseTurn];
    self.deal.enabled = YES;
    
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
