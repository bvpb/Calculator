//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Victor Ramanauskas on 8/12/11.
//  Copyright (c) 2011 Ramanauskas Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)clearStack;
- (double)performOperation:(NSString *)operation;


@end
