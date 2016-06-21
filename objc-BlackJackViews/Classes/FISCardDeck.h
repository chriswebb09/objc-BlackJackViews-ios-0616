//
//  FISCardDeck.h
//  
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//
//
#import <Foundation/Foundation.h>
#import "FISCard.h"

@interface FISCardDeck : NSObject

@property (strong, nonatomic) NSMutableArray *remainingCards;
@property (strong, nonatomic) NSMutableArray *dealtCards;

-(FISCard *) drawNextCard;
-(void)resetDeck;
-(void)gatherDealtCards;
-(void)shuffleRemainingCards;

@end

