//
//  FISCard.m
//  
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//
//

#import "FISCard.h"


@interface FISCard ()

@property (strong, nonatomic, readwrite) NSString *cardLabel;
@property (nonatomic, readwrite) NSUInteger cardValue;

@end


@implementation FISCard

-(instancetype)init{
    
    self = [self initWithSuit:@"!" rank:@"N"];
    
    return self;
}

-(instancetype)initWithSuit:(NSString *)suit rank:(NSString *)rank{
    
    self = [super init];
    
    if (self) {
        _suit = suit;
        _rank = rank;
        _cardLabel = [NSString stringWithFormat:@"%@%@", suit, rank];
        _cardValue = [[FISCard validRanks] indexOfObject:rank]+1;
        if(_cardValue > 10){
            _cardValue = 10;
        }
    }
    
    return self;
}

-(NSString *)description{
    return _cardLabel;
}



+(NSArray *)validSuits{
    
    return @[@"♠", @"♥", @"♣", @"♦"];
    
}



+(NSArray *)validRanks{
    
    return @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    
}


@end
