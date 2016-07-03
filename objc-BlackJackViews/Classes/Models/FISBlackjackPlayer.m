//
//  FISBlackjackPlayer.m
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackPlayer.h"

@implementation FISBlackjackPlayer

-(instancetype) init {
    
    self = [self initWithName:@""];
    
    return self;
}

-(instancetype) initWithName:(NSString *)name{
    
    self = [super init];
    
    if (self) {
        _name = name;
        _cardsInHand = [[NSMutableArray alloc] init];
        _handscore = 0;
        _wins = 0;
        _losses = 0;
        _aceInHand = NO;
        _blackjack = NO;
        _busted = NO;
        _stayed = NO;
    }
    
    return self;
}



-(void)resetForNewGame{
    
    //maybe use a convenience initializer and call on that!
    
    [self.cardsInHand removeAllObjects];
    self.handscore = 0;
    self.aceInHand = NO;
    self.stayed = NO;
    self.blackjack = NO;
    self.busted = NO;
    
}


-(NSUInteger)detectAce{
    
    NSUInteger aceCount = 0;
    
    for (FISCard *card in self.cardsInHand){
        if([card.rank isEqualToString:@"A"]){
            self.aceInHand = YES;
            aceCount ++;
        }
    }
    
    return aceCount;
}


-(void)acceptCard:(FISCard *)card{
    
    //REFACTOR THIS LATER!
    //do not need to loop through self.cardsInHand b/c the test automatically runs this for each card in hand
    
    [self.cardsInHand addObject:card];
    // NSLog(@"\n\n\n\n\n\n\n\nthe card is: %@", card.cardLabel);
    
    NSUInteger score = card.cardValue;
    
    if([self detectAce] > 0){
        
        if (self.handscore <= 11 && [self detectAce] == 1)
            score = 11;
        else if (self.handscore > 11 || [self detectAce] > 1){
            score = 1;
        }
    }
    else {
        score = card.cardValue;
    }
    
    self.handscore += score;
    
    if(self.handscore > 21){
        self.busted = YES;
        return;
    }
    else if (self.handscore == 21){
        self.blackjack = YES;
        return;
    }
    
    // NSLog(@"score is: %lu, total handscore: %lu", score, self.handscore);
}



-(BOOL)shouldHit{
    
    if(self.handscore >= 16){
        self.stayed = YES;
        NSLog(@"%@", [NSString stringWithFormat:@"%@ has decided to stay at a score of %lu", self.name, self.handscore]);
        return NO;
    }
    
    return YES;
}

-(NSString *)description{
    
    NSMutableString *playerInfo = [[NSMutableString alloc] initWithFormat:@"\nname: %@ \ncards: ", self.name];
    
    for(FISCard *card in self.cardsInHand){
        [playerInfo appendFormat:@"%@ ", card.cardLabel];
    }
    
    [playerInfo appendFormat:@"\nhandscore: %lu \nace in hand: %d \nstayed: %d \nblackjack: %d \nbusted: %d \nwins: %lu \nlosses: %lu", self.handscore, self.aceInHand, self.stayed, self.blackjack, self.busted, self.wins, self.losses];
    
    // refactor opportunity: call on initializer (make convenience?) to print out info?
    
    return playerInfo;
}

@end
