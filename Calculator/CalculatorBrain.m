//
//  CalculatorBrain.m
//  Calculator
//
//  Created by bvpb on 8/12/11.
//  Copyright (c) 2011 bvpb. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *testVariableValues; 
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize testVariableValues;

// used to keep track of last operator in order to correctly display brackets
static NSString *previousOperator;

- (NSMutableArray *)programStack 
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program 
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) 
    {
        description = [topOfStack stringValue];
    } 
    else if ([topOfStack isKindOfClass:[NSString class]]) 
    {
        NSString *operation = topOfStack;
        if ([self isAUnaryOperation:operation]) {
            description = [NSString stringWithFormat:@"%@(%@)", operation, [self descriptionOfTopOfStack:stack]];
            
        } else if ([self isABinaryOperation:operation]) {

            NSString *format = @"";             
            if ([self isAdditionOrSubtraction:operation] && [self isMultiplicationOrDivision:previousOperator])  {
                
                format = @"(%@ %@ %@)";
            } else {
                format = @"%@ %@ %@";
            }
            previousOperator = operation;
            NSString *secondOperand = [self descriptionOfTopOfStack:stack];
            NSString *firstOperand = [self descriptionOfTopOfStack:stack];
            
            
            BOOL emptyStack = NO;
            if ([stack lastObject]) {
                emptyStack = YES;
            } 
            
            description = [NSString stringWithFormat:format, firstOperand, operation, secondOperand];
            
            previousOperator = operation; // to be used in the next iteration
        } else {
            // Is a variable
            description = [NSString stringWithFormat:@"%@", topOfStack];
        }
        
    }
    
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *description = [self descriptionOfTopOfStack:stack];
    while ([stack count]) {
        previousOperator = @"";
        description = [NSString stringWithFormat:@"%@, %@", [self descriptionOfTopOfStack:stack], description];
    }
    return description;
}

- (NSString *) description 
{
    return [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)pushOperand:(double)operand 
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation 
{
    [self.programStack addObject:operation];
    return [self executeProgram];
}

- (double)executeProgram {
    if (!testVariableValues) {
        return [[self class] runProgram:self.program];
    } else {
        return [[self class] runProgram:self.program usingVariableValues:testVariableValues];
    }

}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack 
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) 
    {
        result = [topOfStack doubleValue];
    } 
    else if ([topOfStack isKindOfClass:[NSString class]]) 
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;   
        } else {
            result = 0;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
} 

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues; 
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    // go through stack, replace variables with values in variableValues if they exist
    for (id operand in program)
    {
        if (![operand isKindOfClass:[NSNumber class]])
        {
            if (![self isOperation:operand]) {
                [stack replaceObjectAtIndex:[stack indexOfObject:operand] withObject:[NSNumber numberWithDouble:[[variableValues objectForKey:operand] doubleValue]]];
                
            }
        }
    }
    
    return [self popOperandOffProgramStack:stack];
    
}

+ (NSSet *)variablesUsedInProgram:(id)program 
{
    NSMutableSet *variables = [NSMutableSet set];
    
    for (id operand in program) 
    {
        if (![operand isKindOfClass:[NSNumber class]])
        {
            if (![self isOperation:operand]) 
            {
                [variables addObject:operand];
            }
        }
    }
    return [variables copy];
}

- (NSString *)variablesDescription {
    NSString *descriptionOfVariablesUsed = @"";
    NSSet *variablesBeingUsed = [[self class] variablesUsedInProgram:self.program];
    for (NSString *variable in variablesBeingUsed) {
        if ([testVariableValues objectForKey:variable]) {
            descriptionOfVariablesUsed = [descriptionOfVariablesUsed stringByAppendingString:[NSString stringWithFormat:@"%@: %@  ", variable, [testVariableValues objectForKey:variable]]];
        }
    }
    return descriptionOfVariablesUsed;
}

- (void)setTestVariables:(NSString *)testNumber {
    if ([testNumber isEqualToString:@"1"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"x", @"3", @"a", @"9", @"b", nil];
    } else if ([testNumber isEqualToString:@"2"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"x", @"7.26", @"a", @"-1", @"b", nil];
    } else if ([testNumber isEqualToString:@"3"]) {
        self.testVariableValues = nil;
    }
}

+ (BOOL)isOperation:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"+", @"*", @"/", @"-", @"sqrt", @"sin", @"cos", @"π", nil];
    if ([operations containsObject:operation]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isABinaryOperation:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"+", @"*", @"/", @"-", nil];
    if ([operations containsObject:operation]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isAUnaryOperation:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"sqrt", @"sin", @"cos", nil];
    if ([operations containsObject:operation]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isMultiplicationOrDivision:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"*", @"/", nil];
    if ([operations containsObject:operation]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isAdditionOrSubtraction:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"+", @"-", nil];
    if ([operations containsObject:operation]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}

- (void)removeLastItem {
    [self.programStack removeLastObject];
}

@end
