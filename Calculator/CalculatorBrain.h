//
//  CalculatorBrain.h
//  Calculator
//
//  Created by bvpb on 8/12/11.
//  Copyright (c) 2011 bvpb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)clearStack;
- (void)removeLastItem;
- (double)performOperation:(NSString *)operation;
- (NSString *)description;
- (NSString *)variablesDescription;
- (void)setTestVariables:(NSString *)testNumber;
- (double)executeProgram; // This is a wrapper for the 2 runPrograms, needs a better name

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isOperation:(NSString *)operation;
+ (BOOL)isABinaryOperation:(NSString *)operation;
+ (BOOL)isAUnaryOperation:(NSString *)operation;
+ (BOOL)isMultiplicationOrDivision:(NSString *)operation;
+ (BOOL)isAdditionOrSubtraction:(NSString *)operation;



@end
