//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()

-(void)concludeRound;
-(void)updateViews;
-(void)showPlayerCards;
-(void)showHouseCards;

-(void)showActiveStatusLabels;
-(void)updatePlayerScoreLabel;
-(void)updateHouseScoreLabel;
-(void)displayHouseHand;
-(void)displayWinner;
-(void)updateWinsAndLossesLabels;
-(void)newRound;
-(BOOL)playerMayHit;
-(void)updateScore;
-(void)updateViews;
-(void)updateHouseLabels;
-(void)houseTurn;

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.houseCardViews = @[self.houseCard1Label, self.houseCard2Label, self.houseCard3Label, self.houseCard4Label, self.houseCard5Label];
    self.playCardViews = @[self.playerCard1Label, self.playerCard2Label, self.playerCard3Label, self.playerCard4Label, self.playerCard5Label];
    self.game = [[FISBlackjackGame alloc]init];
    [self newGame];
    // Do view setup here.
}


-(void)newRound {
    
    self.dealButton.enabled = YES;
    self.hitButton.enabled = NO;
    self.stayButton.enabled = NO;
    
}


-(void)newGame {
    
    self.playerCard1Label.hidden = YES;
    self.playerCard2Label.hidden = YES;
    self.playerCard3Label.hidden = YES;
    self.playerCard4Label.hidden = YES;
    self.playerCard5Label.hidden = YES;
    
    
    self.houseCard1Label.hidden = YES;
    self.houseCard2Label.hidden = YES;
    self.houseCard3Label.hidden = YES;
    self.houseCard4Label.hidden = YES;
    self.houseCard5Label.hidden = YES;
    
    
    self.winnerLabel.hidden = YES;
    self.playerBust.hidden = YES;
    self.playerBlackjack.hidden = YES;
    self.houseScoreLabel.hidden = YES;
    self.houseBustLabel.hidden = YES;
    self.houseStayedLabel.hidden = YES;
    self.playerStayedLabel.hidden = YES;
    self.houseBlackjackLabel.hidden = YES;
    
    [self newRound];
    
}


- (void)updateViews {
    [self showHouseCards];
    [self showPlayerCards];
    [self showActiveStatusLabels];
    [self updatePlayerScoreLabel];
    
    if ([self playerMayHit]) {
        self.winnerLabel.hidden = YES;
        self.houseScoreLabel.hidden = YES;
    }
}

- (BOOL)playerMayHit {
    BOOL playerMayHit = !self.game.player.busted && !self.game.player.stayed && !self.game.player.blackjack;
    return playerMayHit;
}

- (void)playerTurn {
    [self.game dealCardToPlayer];
    [self updateViews];
    
    BOOL playerMayHit = [self playerMayHit];
    
    if (!playerMayHit) {
        self.hitButton.enabled = NO;
        self.stayButton.enabled = NO;
        [self concludeRound];
    }
    
    
}


- (void)finishHouseTurns {
    for (NSUInteger i = self.game.house.cardsInHand.count; i < 5; i++) {
        BOOL houseMayHit = !self.game.house.busted && !self.game.house.stayed && !self.game.house.blackjack;
        if (houseMayHit) {
            [self.game processHouseTurn];
        }
    }
}

- (void)concludeRound {
    self.dealButton.enabled = YES;
    self.hitButton.enabled = NO;
    self.stayButton.enabled = NO;
    
    if (!self.game.player.busted) {
        [self finishHouseTurns];
    }
    
    [self updateViews];
    
    [self displayHouseHand];
    [self displayHouseScore];
    [self displayWinner];
    [self updateWinsAndLossesLabels];
}



- (void)displayHouseScore {
    NSUInteger houseScore = self.game.house.handscore;
    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", houseScore];
    self.houseScoreLabel.hidden = NO;
}

-(void)displayWinner {
    
    BOOL houseWins = [self.game houseWins];
    [self.game incrementWinsAndLossesForHouseWins:houseWins];

    if (houseWins) {
        self.winnerLabel.text = @"You lose!";
    }
    
}


-(void)updatePlayerCardLabels {
    
    FISCard *playerCard1 = self.game.player.cardsInHand[0];
    FISCard *playerCard2 = self.game.player.cardsInHand[1];
    
    UILabel *cardLabel1 = self.playCardViews[0];
    UILabel *cardLabel2 = self.playCardViews[1];
    
    cardLabel1.text = playerCard1.cardLabel;
    cardLabel2.text = playerCard2.cardLabel;
    
    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
        FISCard *displayCard  = self.game.player.cardsInHand[i];
        UILabel *displayCardLabel = self.playCardViews[i];
        displayCardLabel.hidden = FALSE;
        displayCardLabel.text = displayCard.cardLabel;
    }
}

-(void)displayPlayerHand {
    FISCard *faceDownPlayerCard = self.game.player.cardsInHand[0];
    self.playerCard1Label.text = faceDownPlayerCard.cardLabel;
}

-(void)updatePlayerScoreLabel {
    
    NSUInteger playerScore = self.game.player.handscore;
    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", playerScore];
    
    
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


-(void)showActiveStatusLabels {
    self.houseStayedLabel.hidden = !self.game.house.stayed;
    self.houseBustLabel.hidden = !self.game.house.busted;
    self.houseBlackjackLabel.hidden = !self.game.house.blackjack;
    
    self.playerStayedLabel.hidden = !self.game.player.stayed;
    self.playerBust.hidden = !self.game.player.busted;
    self.playerBlackjack.hidden = !self.game.player.blackjack;
}

//-(BOOL)playerMayHit {
//    BOOL playerMayHit = !self.game.player.busted && !self.game.player.stayed && !self.game.player.blackjack;
//    return playerMayHit;
//}


- (IBAction)hitButtonTapped:(id)sender {
    [self.game dealCardToPlayer];
    [self updatePlayerCardLabels];
    [self updatePlayerScoreLabel];
    [self showActiveStatusLabels];
}


- (IBAction)stayButtonTapped:(id)sender {
    self.hitButton.enabled = FALSE;
    [self houseTurn];
    [self.game processHouseTurn];
    self.dealButton.enabled = FALSE;
    
}

-(void)updateWinsAndLossesLabels {
    self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
    self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses %lu", self.game.house.losses];
    self.playerWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
    self.playerLosses.text = [NSString stringWithFormat:@"Losses %lu", self.game.player.losses];
}


- (IBAction)dealButtonTapped:(id)sender {
    
    self.dealButton.enabled = NO;
    self.hitButton.enabled = YES;
    self.stayButton.enabled = YES;
    
    [self.game.deck resetDeck];
    [self.game.house resetForNewGame];
    [self.game.player resetForNewGame];
    [self.game dealNewRound];
    
    [self updateViews];
    
        if (![self playerMayHit]) {
            [self concludeRound];
        }
}




//-(void)showPlayerCards {
//    for (NSUInteger i = 0; i < self.playCardViews.count; i++) {
//        UILabel *playerCardView = self.playCardViews[i];
//        if (i < self.game.player.cardsInHand.count) {
//            FISCard *card = self.game.player.cardsInHand[0];
//            playerCardView.text = card.cardLabel;
//        } else {
//            playerCardView.text = @"";
//        }
//
//        if (playerCardView.text.length > 0) {
//            playerCardView.hidden = NO;
//        } else {
//            playerCardView.hidden = YES;
//        }
//    }
//}

//-(void)showHouseCards {
//    for (NSUInteger i = 0; i < self.houseCardViews.count; i++) {
//        UILabel *houseCardView = self.houseCardViews[i];
//        if (i < self.game.house.cardsInHand.count) {
//            FISCard *card = self.game.house.cardsInHand[0];
//            houseCardView.text = card.cardLabel;
//        } else {
//            houseCardView.text = @"";
//        }
//
//        if (houseCardView.text.length > 0) {
//            houseCardView.hidden = NO;
//        } else {
//            houseCardView.hidden = YES;
//        }
//    }
//}




//-(void)newGame {
//    self.playerCard1Label.hidden = YES;
//    self.playerCard2Label.hidden = YES;
//    self.playerCard3Label.hidden = YES;
//    self.playerCard4Label.hidden = YES;
//    self.playerCard5Label.hidden = YES;
//    self.houseCard1Label.hidden = YES;
//    self.houseCard2Label.hidden = YES;
//    self.houseCard3Label.hidden = YES;
//    self.houseCard4Label.hidden = YES;
//    self.houseCard5Label.hidden = YES;
//    
//    self.winnerLabel.hidden = YES;
//    self.playerBust.hidden = YES;
//    self.playerBlackjack.hidden = YES;
//    self.houseScoreLabel.hidden = YES;
//    self.houseBustLabel.hidden = YES;
//    self.houseStayedLabel.hidden = YES;
//    self.playerStayedLabel.hidden = YES;
//    self.houseBlackjackLabel.hidden = YES;
//}
//
//
//-(void)finishHouseTurn {
//    [self updateHouseScoreLabel];
//    
//}
//
//-(void)updateViews {
//    [self showHouseCards];
//    [self showPlayerCards];
//    [self showActiveStatusLabels];
//    [self updatePlayerLabels];
//    
//    if ([self playerMayHit]) {
//        self.winnerLabel.hidden = YES;
//        self.houseScoreLabel.hidden = YES;
//    }
//}
//
//
//-(void)showPlayerCards {
//    for (NSUInteger i = 0; i < self.playCardViews.count; i++) {
//        UILabel *playerCardView = self.playCardViews[i];
//        if (i < self.game.player.cardsInHand.count) {
//            FISCard *card = self.game.player.cardsInHand[0];
//            playerCardView.text = card.cardLabel;
//        } else {
//            playerCardView.text = @"";
//        }
//        
//        if (playerCardView.text.length > 0) {
//            playerCardView.hidden = NO;
//        } else {
//            playerCardView.hidden = YES;
//        }
//    }
//}
//
//
//-(void)showHouseCards {
//    for (NSUInteger i = 0; i < self.houseCardViews.count; i++) {
//        UILabel *houseCardView = self.houseCardViews[i];
//        if (i < self.game.house.cardsInHand.count) {
//            FISCard *card = self.game.house.cardsInHand[0];
//            houseCardView.text = card.cardLabel;
//        } else {
//            houseCardView.text = @"";
//        }
//        
//        if (houseCardView.text.length > 0) {
//            houseCardView.hidden = NO;
//        } else {
//            houseCardView.hidden = YES;
//        }
//    }
//}
//
//-(void)showActiveStatusLabels {
//    self.houseStayedLabel.hidden = !self.game.house.stayed;
//    self.houseBustLabel.hidden = !self.game.house.busted;
//    self.houseBlackjackLabel.hidden = !self.game.house.blackjack;
//    
//    self.playerStayedLabel.hidden = !self.game.player.stayed;
//    self.playerBust.hidden = !self.game.player.busted;
//    self.playerBlackjack.hidden = !self.game.player.blackjack;
//}
//
//-(void)updatePlayerScoreLabel {
//    NSUInteger playerScore = self.game.player.handscore;
//    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", playerScore];
//    
//}
//
//
//-(void)updateHouseScoreLabel {
//    NSUInteger houseScore = self.game.house.handscore;
//    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", houseScore];
//}
//
//
//-(void)displayHouseHand {
//    FISCard *faceDownHouseCard = self.game.house.cardsInHand[0];
//    self.houseCard1Label.text = faceDownHouseCard.cardLabel;
//}
//
//
//-(void)displayPlayerHand {
//    FISCard *faceDownPlayerCard = self.game.player.cardsInHand[0];
//    self.playerCard1Label.text = faceDownPlayerCard.cardLabel;
//}
//
//-(void)displayHouseScore {
//    NSUInteger houseScore = self.game.house.handscore;
//    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", houseScore];
//    self.houseScoreLabel.hidden = NO;
//}
//
//
//-(void)displayWinner {
//    BOOL houseWins = [self.game houseWins];
//    [self.game incrementWinsAndLossesForHouseWins:houseWins];
//    
//    if (houseWins) {
//        self.winnerLabel.text = @"You lose!";
//    }
//}
//
//
//-(void)updatePlayerLabels {
//    [self displayPlayerHand];
//    [self updatePlayerScoreLabel];
//    [self showActiveStatusLabels];
//}
//
//
//- (IBAction)dealButtonTapped:(id)sender {
//    self.dealButton.enabled = NO;
//    self.hitButton.enabled = YES;
//    self.stayButton.enabled = YES;
//    
//    [self.game.deck resetDeck];
//    [self.game.house resetForNewGame];
//    [self.game.player resetForNewGame];
//    [self.game dealNewRound];
//    
//    [self updateViews];
//    
//    if (![self playerMayHit]) {
//        [self concludeRound];
//    }
//}
//
//
//
//-(void)concludeRound {
//    self.dealButton.enabled = YES;
//    self.hitButton.enabled = NO;
//    self.stayButton.enabled = NO;
//    
//    if (!self.game.player.busted) {
//        [self finishHouseTurn];
//    }
//    
//    [self updateViews];
//    [self displayHouseHand];
//    [self displayHouseScore];
//    [self displayWinner];
//    [self updateWinsAndLossesLabels];
//}
//
//-(void)playerTurn {
//    [self.game dealCardToPlayer];
//    [self showPlayerCards];
//    [self updatePlayerLabels];
//}
//
//
//- (IBAction)hitButtonTapped:(id)sender {
//    [self playerTurn];
//    // [self showPlayerCards];
////    if (!self.game.player.busted) {
////        [self houseTurn];
////    }
//}
//
//
//-(BOOL)playerMayHit {
//    BOOL playerMayHit = !self.game.player.busted && !self.game.player.stayed && !self.game.player.blackjack;
//    return playerMayHit;
//}
//
//
//- (IBAction)stayButtonTapped:(id)sender {
//    self.game.player.stayed = YES;
//    self.hitButton.enabled = NO;
//    self.stayButton.enabled = NO;
//    [self updateViews];
//    [self concludeRound];
//    
//}
//
//-(void)updateWinsAndLossesLabels {
//    self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
//    self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses %lu", self.game.house.losses];
//    self.playerWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
//    self.playerLosses.text = [NSString stringWithFormat:@"Losses %lu", self.game.player.losses];
//}
//





























//- (IBAction)dealButtonTapped:(id)sender {
//    //[self.game.deck shuffleRemainingCards];
//    [self newRound];
//    [self.game dealCardToPlayer];
//    [self updateLabels];
//    self.hitButton.enabled = TRUE;
//    self.stayButton.enabled = TRUE;
//}
//
//
//-(void)newRound {
//    [self.game dealNewRound];
//    [self updateLabels];
//    self.houseCard3Label.hidden = YES;
//    self.houseCard4Label.hidden = YES;
//    self.houseCard5Label.hidden = YES;
//    self.playerCard3Label.hidden = YES;
//    self.playerCard4Label.hidden = YES;
//    self.playerCard5Label.hidden = YES;
//    self.playerBust.hidden = YES;
//    self.playerBlackjack.hidden = YES;
//    self.houseBlackjackLabel.hidden = YES;
//    self.houseBustLabel.hidden = YES;
//    self.houseStayedLabel.hidden = YES;
//    self.winnerLabel.hidden = YES;
//    self.playerStayedLabel.hidden = YES;
//}
//
//
//- (IBAction)hitButtonTapped:(id)sender {
//    [self.game dealCardToPlayer];
//    [self updateLabels];
//}
//
//
//- (IBAction)stayButtonTapped:(id)sender {
//    self.hitButton.enabled = FALSE;
//    self.stayButton.enabled = FALSE;
//    [self.game processPlayerTurn];
//    [self houseTurn];
//}
//
//
//-(void)newGame {
//    [self newRound];
//    [self.game.deck shuffleRemainingCards];
//}
//
//
//-(void)updateViews {
//
//}
//
//
//-(void)updateScore {
//    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.player.handscore];
//    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.house.handscore];
//    self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %li ", self.game.house.wins];
//    self.playerWins.text = [NSString stringWithFormat:@"Wins: %li ", self.game.player.wins];
//}
//
//
//
//
//-(void)turnCardOver {
//    
//}
//
//-(void)updateLabels {
//    FISCard *playerCard1 = self.game.player.cardsInHand[0];
//    FISCard *playerCard2 = self.game.player.cardsInHand[1];
//    self.playerCard1Label.text = playerCard1.cardLabel;
//    self.playerCard2Label.text = playerCard2.cardLabel;
//    
//    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
//        FISCard *displayCard  = self.game.player.cardsInHand[i];
//        if (i == 2) {
//            self.playerCard3Label.hidden = FALSE;
//            self.playerCard3Label.text = displayCard.cardLabel;
//        } else if (i == 3) {
//            self.playerCard4Label.hidden = FALSE;
//            self.playerCard4Label.text = displayCard.cardLabel;
//        } else if (i == 4) {
//            self.playerCard5Label.hidden = FALSE;
//            self.playerCard5Label.text = displayCard.cardLabel;
//        } else {
//            break;
//        }
//    }
//}
//
//
//-(void)houseTurn {
//    while (self.game.house.shouldHit) {
//        [self houseHit];
//    }
//    [self.game processHouseTurn];
//}
//
//-(void)houseHit {
//    [self.game dealCardToHouse];
//    [self updateHouseLabels];
//    [self updateScore];
//}
//
//
//-(void)updateHouseLabels {
//    for (NSUInteger i = 0; i < self.game.house.cardsInHand.count; i++) {
//        FISCard *displayCard  = self.game.house.cardsInHand[i];
//        if (i == 0) {
//            self.houseCard1Label.text = displayCard.cardLabel;
//        } else if (i == 1) {
//            self.houseCard2Label.text = displayCard.cardLabel;
//        } else if (i == 2) {
//            self.houseCard3Label.hidden = FALSE;
//            self.houseCard3Label.text = displayCard.cardLabel;
//        } else if (i == 3) {
//            self.houseCard4Label.hidden = FALSE;
//            self.playerCard4Label.text = displayCard.cardLabel;
//        } else if (i == 4) {
//            self.houseCard5Label.hidden = FALSE;
//            self.houseCard5Label.text = displayCard.cardLabel;
//        } else {
//            break;
//        }
//    }
//}



//-(void)updateHouseLabels {
//    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
//        FISCard *displayCard  = self.game.player.cardsInHand[i];
//        if (i == 0) {
//            self.playerCard1Label.text = displayCard.cardLabel;
//        } else if (i == 1) {
//            self.playerCard2Label.text = displayCard.cardLabel;
//        } else if (i == 2) {
//            self.playerCard3Label.hidden = FALSE;
//            self.playerCard3Label.text = displayCard.cardLabel;
//        } else if (i == 3) {
//            self.playerCard4Label.hidden = FALSE;
//            self.playerCard4Label.text = displayCard.cardLabel;
//        } else if (i == 4) {
//            self.playerCard5Label.hidden = FALSE;
//            self.playerCard5Label.text = displayCard.cardLabel;
//        } else {
//            break;
//        }
//    }
//    
//}





//    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
//        FISCard *scoreCard = self.game.player.cardsInHand[i];
//        self.playerScore += scoreCard.cardValue;
//    }
//

//    if (self.game.house.shouldHit && self.game.house.cardsInHand.count < 5) {
//        for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
//            FISCard *displayCard  = self.game.player.cardsInHand[i];
//            if (i == 2) {
//                self.playerCard3Label.hidden = FALSE;
//                self.playerCard3Label.text = displayCard.cardLabel;
//            } else if (i == 3) {
//                self.playerCard4Label.hidden = FALSE;
//                self.playerCard4Label.text = displayCard.cardLabel;
//            } else if (i == 4) {
//                self.houseCard5Label.hidden = FALSE;
//                self.houseCard5Label.text = displayCard.cardLabel;
//            }
//            
//        }
//        [self.game dealCardToHouse];
//    }
//    [self.game processHouseTurn];

//    [self.game dealCardToHouse];
//    self.houseCard1Label.hidden = FALSE;
//    self.houseCard2Label.hidden = FALSE;
//    if (self.game.house.shouldHit) {
//        [self.game dealCardToHouse];
//        [self updateHouseLabels];
//    }
//    NSLog(@"%@", self.game.house.cardsInHand);
//    for (NSUInteger i = 0; i < self.game.house.cardsInHand.count; i++) {
//        FISCard *displayCard  = self.game.house.cardsInHand[i];
//        if (i == 0) {
//            self.houseCard1Label.text = displayCard.cardLabel;
//        } else if (i == 1) {
//            self.houseCard2Label.text = displayCard.cardLabel;
//        } else if (i == 2) {
//            //self.houseCard3Label.hidden = FALSE;
//            self.houseCard3Label.text = displayCard.cardLabel;
//        } else if (i == 3) {
//            self.houseCard4Label.hidden = FALSE;
//            self.houseCard4Label.text = displayCard.cardLabel;
//        } else if (i == 4) {
//            self.houseCard5Label.hidden = FALSE;
//            self.houseCard5Label.text = displayCard.cardLabel;
//        } else {
//            break;
//        }
//    }
////    self.houseCard3Label.hidden = FALSE;
////    FISCard *houseDisplayCard = self.game.house.cardsInHand[2];
////    self.houseCard3Label.text = houseDisplayCard.cardLabel;
//    
//    //self.houseCard3Label.text = [self.game.house.cardsInHand lastObject
//    if (self.game.house.handscore > 21) {
//        self.game.player.wins += 1;
//        self.playerWins.text = [NSString stringWithFormat:@"Wins: %li",self.game.player.wins];
//        self.winnerLabel.hidden = FALSE;
//        [self.game dealNewRound];
//    }
//




    

    
    
    
    
    
    
    //}
    //- (IBAction)dealButtonTapped:(id)sender {
    //
    //
    //
    //
    //
    ////
    ////
    ////    [self newRound];
    ////    [self.game.deck shuffleRemainingCards];
    //    //[self newRound];
    //    //self updateScore];
    ////    [self updateViews];
    ////    self.hitButton.enabled = TRUE;
    ////    self.stayButton.enabled = TRUE;
    //
    ////    FISCard *houseCard1 = self.game.house.cardsInHand[0];
    ////    FISCard *houseCard2 = self.game.house.cardsInHand[1];
    ////    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li",
    ////                                  self.playerScore];
    ////
    ////
    //
    ////    [self newGame];
    ////
    ////     = self.game.player.cardsInHand[0];
    ////    self.playerCard2 = self.game.player.cardsInHand[1];
    ////
    ////    self.houseCard1 = self.game.house.cardsInHand[0];
    ////    self.houseCard2 = self.game.house.cardsInHand[1];
    ////
    ////    self.playerScore += (self.playerCard1.cardValue + self.playerCard2.cardValue);
    ////    self.dealerScore += (self.houseCard1.cardValue + self.houseCard2.cardValue);
    ////
    ////    self.playerCard1Label.text = self.playerCard1.cardLabel;
    ////    self.playerCard2Label.text = self.playerCard2.cardLabel;
    ////    self.houseCard1Label.text = self.houseCard1.cardLabel;
    ////    self.houseCard2Label.text = self.houseCard2.cardLabel;
    ////
    ////    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.playerScore];
    ////    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.dealerScore];
    //}
    //
    //
    //-(void)newRound {
    ////    self.houseCard3Label.hidden = TRUE;
    ////    self.houseCard4Label.hidden = TRUE;
    ////    self.houseCard5Label.hidden = TRUE;
    ////    self.houseBustLabel.hidden = TRUE;
    ////    self.playerBlackjack.hidden = TRUE;
    ////    self.winnerLabel.hidden = TRUE;
    ////    self.houseCard1Label.text = @"";
    ////    self.houseCard2Label.text = @"";
    ////    self.playerCard1Label.text = @"";
    ////    self.playerCard2Label.text = @"";
    ////    self.playerCard3Label.hidden = TRUE;
    ////    self.playerCard4Label.hidden = TRUE;
    ////    self.playerCard5Label.hidden = TRUE;
    ////    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.playerScore];
    ////    [self.game dealNewRound];
    //}
    //
    //
    //- (IBAction)hitButtonTapped:(id)sender {
    ////    [self.game dealCardToPlayer];
    ////    [self updateViews];
    ////    self.playerCard3 = [self.game.player.cardsInHand lastObject];
    ////    self.playerCard3Label.hidden = FALSE;
    ////    self.playerCard3Label.text = self.playerCard3.cardLabel;
    ////    self.playerScore += self.playerCard3.cardValue;
    ////    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.playerScore];
    //}
    //
    //
    //- (IBAction)stayButtonTapped:(id)sender {
    //    self.hitButton.enabled = FALSE;
    //    [self houseTurn];
    ////    [self.game processHouseTurn];
    //    //self.dealButton.enabled = FALSE;
    //
    //}
    //
    //
    //-(void)newGame {
    //    [self newRound];
    //    self.playerWins.text = [NSString stringWithFormat:@"Wins: 0"];
    //    [self.game dealNewRound];
    //}
    //
    //
    //-(void)updateViews {
    //    [self updateScore];
    //    [self updateLabels];
    //   // [self updateHouseLabels];
    //    //[self houseTurn];
    //
    //}
    //
    //
    //-(void)updateScore {
    //    if (self.game.player.handscore > 21) {
    //        self.playerBust.hidden = FALSE;
    //        [self.game processPlayerTurn];
    //    } else if (self.game.player.handscore == 21) {
    //        self.playerBlackjack.hidden = FALSE;
    //        self.winnerLabel.hidden = FALSE;
    //        self.game.player.wins += 1;
    //        self.playerWins.text = [NSString stringWithFormat:@"Wins: %li",self.game.player.wins];
    //        [self.game processPlayerTurn];
    //    } else if (self.game.house.handscore > 21) {
    //        self.houseBustLabel.hidden = FALSE;
    //        self.winnerLabel.hidden = FALSE;
    //        self.game.player.wins += 1;
    //        self.game.house.losses += 1;
    //        self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses: %li",self.game.house.losses];
    //    }
    //}
    ////    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
    ////        FISCard *scoreCard = self.game.player.cardsInHand[i];
    ////        self.playerScore += scoreCard.cardValue;
    ////    }
    ////
    //
    //
    //
    //
    //
    //
    //-(void)houseTurn {
    //    self.hitButton.enabled = FALSE;
    //    self.stayButton.enabled = FALSE;
    //    self.houseCard1Label.hidden = FALSE;
    //    FISCard *houseTurnCard1 = self.game.house.cardsInHand[0];
    //    self.houseCard1Label.text = houseTurnCard1.cardLabel;
    //    self.houseCard2Label.hidden = FALSE;
    //    FISCard *houseTurnCard2 = self.game.house.cardsInHand[1];
    //    self.houseCard2Label.text = houseTurnCard2.cardLabel;
    //    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.house.handscore];
    //    //[NSThread sleepForTimeInterval:6.0f];
    //    while (self.game.house.shouldHit) {
    //        [self.game dealCardToHouse];
    //        FISCard *dealtCard = self.game.house.cardsInHand[self.game.house.cardsInHand.count - 1];
    //        NSLog(@"%@", dealtCard);
    //        if (self.game.house.cardsInHand.count == 3) {
    //            self.houseCard3Label.hidden = FALSE;
    //            self.houseCard3Label.text = dealtCard.cardLabel;
    //            self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.house.handscore];
    //            //[NSThread sleepForTimeInterval:2.0f];
    //        } else if (self.game.house.cardsInHand.count == 4) {
    //            self.houseCard4Label.hidden = FALSE;
    //            self.houseCard4Label.text = dealtCard.cardLabel;
    //            self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.house.handscore];
    //        }
    //    }
    //    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.house.handscore];
    //}
    ////    if (self.game.house.shouldHit && self.game.house.cardsInHand.count < 5) {
    ////        for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
    ////            FISCard *displayCard  = self.game.player.cardsInHand[i];
    ////            if (i == 2) {
    ////                self.playerCard3Label.hidden = FALSE;
    ////                self.playerCard3Label.text = displayCard.cardLabel;
    ////            } else if (i == 3) {
    ////                self.playerCard4Label.hidden = FALSE;
    ////                self.playerCard4Label.text = displayCard.cardLabel;
    ////            } else if (i == 4) {
    ////                self.houseCard5Label.hidden = FALSE;
    ////                self.houseCard5Label.text = displayCard.cardLabel;
    ////            }
    ////
    ////        }
    ////        [self.game dealCardToHouse];
    ////    }
    ////    [self.game processHouseTurn];
    //
    ////    [self.game dealCardToHouse];
    ////    self.houseCard1Label.hidden = FALSE;
    ////    self.houseCard2Label.hidden = FALSE;
    ////    if (self.game.house.shouldHit) {
    ////        [self.game dealCardToHouse];
    ////        [self updateHouseLabels];
    ////    }
    ////    NSLog(@"%@", self.game.house.cardsInHand);
    ////    for (NSUInteger i = 0; i < self.game.house.cardsInHand.count; i++) {
    ////        FISCard *displayCard  = self.game.house.cardsInHand[i];
    ////        if (i == 0) {
    ////            self.houseCard1Label.text = displayCard.cardLabel;
    ////        } else if (i == 1) {
    ////            self.houseCard2Label.text = displayCard.cardLabel;
    ////        } else if (i == 2) {
    ////            //self.houseCard3Label.hidden = FALSE;
    ////            self.houseCard3Label.text = displayCard.cardLabel;
    ////        } else if (i == 3) {
    ////            self.houseCard4Label.hidden = FALSE;
    ////            self.houseCard4Label.text = displayCard.cardLabel;
    ////        } else if (i == 4) {
    ////            self.houseCard5Label.hidden = FALSE;
    ////            self.houseCard5Label.text = displayCard.cardLabel;
    ////        } else {
    ////            break;
    ////        }
    ////    }
    //////    self.houseCard3Label.hidden = FALSE;
    //////    FISCard *houseDisplayCard = self.game.house.cardsInHand[2];
    //////    self.houseCard3Label.text = houseDisplayCard.cardLabel;
    ////
    ////    //self.houseCard3Label.text = [self.game.house.cardsInHand lastObject
    ////    if (self.game.house.handscore > 21) {
    ////        self.game.player.wins += 1;
    ////        self.playerWins.text = [NSString stringWithFormat:@"Wins: %li",self.game.player.wins];
    ////        self.winnerLabel.hidden = FALSE;
    ////        [self.game dealNewRound];
    ////    }
    ////
    //
    //
    //-(void)updateHouseLabels {
    //    for (NSUInteger i = 0; i < self.game.house.cardsInHand.count; i++) {
    //        FISCard *displayCard  = self.game.house.cardsInHand[i];
    //        if (i == 0) {
    //            self.houseCard1Label.text = displayCard.cardLabel;
    //        } else if (i == 1) {
    //            self.houseCard2Label.text = displayCard.cardLabel;
    //        } else if (i == 2) {
    //            //self.houseCard3Label.hidden = FALSE;
    //            self.houseCard3Label.text = displayCard.cardLabel;
    //        } else if (i == 3) {
    //            self.houseCard4Label.hidden = FALSE;
    //            self.houseCard4Label.text = displayCard.cardLabel;
    //        } else if (i == 4) {
    //            self.houseCard5Label.hidden = FALSE;
    //            self.houseCard5Label.text = displayCard.cardLabel;
    //        } else {
    //            break;
    //        }
    //    }
    //}
    //
    //
    //-(void)turnCardOver {
    //
    //}
    //
    //-(void)updateLabels {
    //    for (NSUInteger i = 0; i < self.game.player.cardsInHand.count; i++) {
    //        FISCard *displayCard  = self.game.player.cardsInHand[i];
    //        if (i == 0) {
    //            self.playerCard1Label.text = displayCard.cardLabel;
    //        } else if (i == 1) {
    //            self.playerCard2Label.text = displayCard.cardLabel;
    //        } else if (i == 2) {
    //            self.playerCard3Label.hidden = FALSE;
    //            self.playerCard3Label.text = displayCard.cardLabel;
    //        } else if (i == 3) {
    //            self.playerCard4Label.hidden = FALSE;
    //            self.playerCard4Label.text = displayCard.cardLabel;
    //        } else if (i == 4) {
    //            self.playerCard5Label.hidden = FALSE;
    //            self.playerCard5Label.text = displayCard.cardLabel;
    //        } else {
    //            break;
    //        }
    //    }
    //    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.player.handscore];
    //    
    //}





@end
