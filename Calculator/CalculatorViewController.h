//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Victor Ramanauskas on 1/12/11.
//  Copyright (c) 2011 Ramanauskas Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *inputDisplay;
@property (weak, nonatomic) IBOutlet UILabel *negateDisplay;

@end
