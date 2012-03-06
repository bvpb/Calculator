//
//  CalculatorViewController.h
//  Calculator
//
//  Created by bvpb on 1/12/11.
//  Copyright (c) 2011 bvpb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *inputDisplay;
@property (weak, nonatomic) IBOutlet UILabel *negateDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variablesDisplay;

@end
