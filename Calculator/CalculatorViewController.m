//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Victor Ramanauskas on 1/12/11.
//  Copyright (c) 2011 Ramanauskas Enterprises. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL currentNumberContainsADecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize inputDisplay;
@synthesize negateDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize currentNumberContainsADecimalPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;

    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.inputDisplay.text = [self.inputDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.currentNumberContainsADecimalPoint = NO;
}
- (IBAction)operationPressed:(UIButton *)sender {
    NSString *operation = [sender currentTitle];

    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:operation];
    self.inputDisplay.text = [self.inputDisplay.text stringByAppendingString:[operation stringByAppendingString:@" "]];
    if (![operation isEqualToString:@"π"]) { 
        self.inputDisplay.text = [self.inputDisplay.text stringByAppendingString:@"= "];
    }
    self.display.text = [NSString stringWithFormat:@"%g", result];
   
}
- (IBAction)decimalPointPressed:(UIButton *)sender {
    if (!self.currentNumberContainsADecimalPoint) {
        currentNumberContainsADecimalPoint = YES;
        [self digitPressed:sender];
    }  
}
- (IBAction)cancelPressed {

    self.display.text = @"";
    self.inputDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.currentNumberContainsADecimalPoint = NO;
    [self.brain clearStack];
}
- (IBAction)backspacePressed {
    NSUInteger displayLength = [self.display.text length];
    if (displayLength > 0) {
        if (displayLength == 1) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            self.display.text = [self.display.text substringToIndex:displayLength - 1 ];
        }
    }
}


- (void)viewDidUnload {
    [self setInputDisplay:nil];
    [self setNegateDisplay:nil];
    [super viewDidUnload];
}
@end
