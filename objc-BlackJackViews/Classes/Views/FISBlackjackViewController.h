//
//  FISBlackjackViewController.h
//  objc-BlackJackViews
//
//  Created by Christopher Webb-Orenstein on 7/3/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBlackjackGame.h"

@interface FISBlackjackViewController : UIViewController

@property (strong, nonatomic) FISBlackjackGame *game;
@property (strong, nonatomic) NSArray *houseCardViews;
@property (strong, nonatomic) NSArray *playerCardViews;

@end
