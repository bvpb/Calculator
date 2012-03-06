//
//  CalculatorViewController.m
//  Calculator
//
//  Created by bvpb on 1/12/11.
//  Copyright (c) 2011 bvpb. All rights reserved.
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
@synthesize variablesDisplay;
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
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.currentNumberContainsADecimalPoint = NO;
    self.inputDisplay.text = [self.brain description];
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.inputDisplay.text = [self.brain description];
    self.variablesDisplay.text = [self.brain variablesDescription];
    
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
    self.variablesDisplay.text = [self.brain variablesDescription];
}

- (IBAction)backspacePressed {
    NSUInteger displayLength = [self.display.text length];
    if (displayLength > 0) {
        if (displayLength == 1) {
            self.display.text = @"";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            self.display.text = [self.display.text substringToIndex:displayLength - 1 ];
        }
    }
}

- (IBAction)testVariableButtonPressed:(UIButton *)sender {
    [self.brain setTestVariables:[sender.currentTitle substringWithRange:NSMakeRange(5, 1)]];
    self.variablesDisplay.text = [self.brain variablesDescription];
}

- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self backspacePressed];
    } else {
        [self.brain removeLastItem];
        self.display.text = [NSString stringWithFormat:@"%g", [self.brain executeProgram]];
        self.inputDisplay.text = [self.brain description];
        
    }
}

- (void)viewDidUnload {
    [self setInputDisplay:nil];
    [self setNegateDisplay:nil];
    [super viewDidUnload];
}
@end
