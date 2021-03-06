//
//  NSDate+RelativeDate.m
//  NSDate+RelativeDate (Released under MIT License)
//
//  Created by digdog on 9/23/09.
//  Copyright (c) 2009 Ching-Lan 'digdog' HUANG. http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

#import "NSDate+RelativeDate.h"

NSCalendar  *gCurrentCalendar = nil;
NSArray     *gSelectorNames = nil;
NSArray     *gPeriodNames = nil;
NSUInteger  gUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

@implementation NSDate (RelativeDate)


+(void)load
{
    gCurrentCalendar = [NSCalendar currentCalendar];
    gSelectorNames = [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"minute", @"second", nil];
    gPeriodNames = [NSArray arrayWithObjects:@"yr", @"mo", @"w", @"d", @"h", @"m", @"s", nil];
}


- (NSString *)relativeDate
{
    NSDateComponents *components = [gCurrentCalendar components:gUnitFlags fromDate:self toDate:[NSDate date] options:0];
        
    for (NSString *selectorName in gSelectorNames)
    {
        SEL currentSelector = NSSelectorFromString(selectorName);
        NSMethodSignature *currentSignature = [NSDateComponents instanceMethodSignatureForSelector:currentSelector];
        NSInvocation *currentInvocation = [NSInvocation invocationWithMethodSignature:currentSignature];
        
        [currentInvocation setTarget:components];
        [currentInvocation setSelector:currentSelector];
        [currentInvocation invoke];
        
        NSInteger relativeNumber;
        [currentInvocation getReturnValue:&relativeNumber];
        
        if (relativeNumber && relativeNumber != INT32_MAX)
        {
            return [NSString stringWithFormat:@"%d%@", relativeNumber, [gPeriodNames objectAtIndex:[gSelectorNames indexOfObject:selectorName]]];       // needs to be localizable
        }
    }
    
    return @"now";
}

@end
