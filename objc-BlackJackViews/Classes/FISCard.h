//
//  FISCard.h
//  
//
//  Created by Christopher Webb-Orenstein on 6/21/16.
//
//

#import <Foundation/Foundation.h>

@interface FISCard : NSObject

@property (strong, nonatomic, readonly) NSString *suit;
@property (strong, nonatomic, readonly) NSString *rank;
@property (strong, nonatomic, readonly) NSString *cardLabel;
@property (nonatomic, readonly) NSUInteger cardValue;

-(instancetype)init;
-(instancetype)initWithSuit:(NSString *)suit rank:(NSString *)rank;

+(NSArray *)validSuits;
+(NSArray *)validRanks;

@end
