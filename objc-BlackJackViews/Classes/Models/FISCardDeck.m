//
//  FISCardDeck.m
//
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//
//



#import "FISCardDeck.h"

@implementation FISCardDeck

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        _remainingCards = [[NSMutableArray alloc] init];
        _dealtCards = [[NSMutableArray alloc] init];
        [self allCardsInDeck];
    }
    
    return self;
    
}



-(FISCard *) drawNextCard{
    
    if([self.remainingCards count] > 0){
        
        FISCard *nextCard = self.remainingCards.lastObject;
        [self.remainingCards removeObject:nextCard];
        [self.dealtCards addObject:nextCard];
        return nextCard;
        
    }
    
    return nil;
}



-(void)resetDeck{
    
    [self gatherDealtCards];
    [self shuffleRemainingCards];
    
}



-(void)gatherDealtCards{
    
    [self.remainingCards addObjectsFromArray:self.dealtCards];
    [self.dealtCards removeAllObjects];
    
}


-(void)shuffleRemainingCards{
    
    //currently not randomizing everything in remaining cards
    
    NSMutableArray *mRemainingCards = [self.remainingCards mutableCopy];
    [self.remainingCards removeAllObjects];
    
    //    for(NSUInteger i = 0; i <= [mRemainingCards count]; i++){
    //        i = arc4random_uniform((uint32_t)i);
    //        FISCard *randomCard = mRemainingCards[i];
    //        [self.remainingCards addObject:randomCard];
    //        [mRemainingCards removeObjectAtIndex:i];
    //    }
    //    for the above method, NSUInteger i was being randomized at 0, 1, etc. so even though I was using the randomizing method, there wasn't anything to randomize b/c I was only passing in one number each time through the loop.
    
    do {
        
        NSUInteger i = arc4random_uniform((uint32_t)[mRemainingCards count]);
        FISCard *randomCard = mRemainingCards[i];
        [self.remainingCards addObject:randomCard];
        [mRemainingCards removeObjectAtIndex:i];
        
    } while ([mRemainingCards count] > 0);
}

-(NSString *)description{
    
    NSMutableString *remainingCardsCount = [NSMutableString stringWithFormat:@"count: %li \ncards: \n", [self.remainingCards count]];
    
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for(FISCard *card in self.remainingCards){
        [cards addObject:card.cardLabel];
        if([cards count] > 13){
            [cards addObject:@"\n"];
        }
    }
    
    [remainingCardsCount appendFormat:@"%@", [cards componentsJoinedByString:@" "]];
    
    return remainingCardsCount;
}


// PRIVATE METHOD
-(void)allCardsInDeck{
    
    for(NSString *cardSuit in [FISCard validSuits]){
        
        for(NSString *cardRank in [FISCard validRanks]){
            FISCard *card = [[FISCard alloc] initWithSuit:cardSuit rank:cardRank];
            [self.remainingCards addObject:card];
            
        }
    }
    
}


@end
