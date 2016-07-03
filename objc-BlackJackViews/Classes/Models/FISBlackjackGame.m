//
//  FISBlackJackGame.m
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"
#import "FISBlackjackPlayer.h"
#import "FISCardDeck.h"

@implementation FISBlackjackGame

-(instancetype) init{
    
    self = [super init];
    
    if (self){
        
        _deck = [[FISCardDeck alloc] init];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
        
    }
    
    return self;
}

-(void)playBlackjack{
    
    [self dealNewRound];
    [self processPlayerTurn];
    [self processHouseTurn];
    [self houseWins];
    [self incrementWinsAndLossesForHouseWins:[self houseWins]];
    
}



-(void)dealNewRound{
    
    [self.player resetForNewGame];
    [self.house resetForNewGame];
    
    for(NSUInteger i = 0; i < 2; i++){
        [self dealCardToPlayer];
        [self dealCardToHouse];
    }
    
}



-(void)dealCardToPlayer{
    
    [self.player acceptCard:[self.deck drawNextCard]];
    
}



-(void)dealCardToHouse{
    
    [self.house acceptCard:[self.deck drawNextCard]];
    
}



-(void)processPlayerTurn{
    
    if([self.player shouldHit] && !self.player.busted && !self.player.stayed){
        [self dealCardToPlayer];
    }
    
}



-(void)processHouseTurn{
    
    if([self.house shouldHit] && !self.house.busted && !self.house.stayed){
        [self dealCardToHouse];
    }
    
}



-(BOOL)houseWins{
    
    if(self.house.busted || (self.house.blackjack && self.player.blackjack)){
        return NO;
    }
    else if(self.player.busted || self.house.blackjack || self.house.handscore >= self.player.handscore){
        return YES;
    }
    
    return NO;
}



-(void)incrementWinsAndLossesForHouseWins:(BOOL)houseWins{
    
    NSMutableString *winnerOfGame = [[NSMutableString alloc] initWithString:@"...and the winner is: "];
    
    if(houseWins){
        [winnerOfGame appendFormat:@"%@", [self.house.name uppercaseString]];
        self.house.wins++;
        self.player.losses++;
    }
    else{
        [winnerOfGame appendFormat:@"%@", [self.player.name uppercaseString]];
        self.player.wins++;
        self.house.losses++;
    }
    
    [winnerOfGame appendString:@"!!!\n The scores so far are:\n"];
    
    //    NSLog(@"%@", [NSString stringWithFormat:@"house wins: %lu \nhouse losses: %lu \nplayer wins: %lu \nplayer losses: %lu", self.house.wins, self.house.losses, self.player.wins, self.player.losses]);
    
    NSLog(@"%@ \nplayer: \n%@\n\n house: \n%@\n\n", winnerOfGame, self.player.description, self.house.description);
}

@end
