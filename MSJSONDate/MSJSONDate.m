//  MSJSONDate.m
//
//  Copyright (c) 2013 Cory Metcalfe
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


#import "MSJSONDate.h"

// DateTime = "/Date(1363042965203+0600)/"
static NSString *pattern = @"\\/Date\\((-?\\d+)([+-]?\\d*)\\)\\/";

NSString *const MSJSONDateInMilliseconds = @"MSJSONDateInMilliseconds";
NSString *const MSJSONTimeZoneOffsetInMilliseconds = @"MSJSONTimeZoneOffsetInMilliseconds";

@implementation MSJSONDate

+ (NSDictionary *)parseString:(NSString *)jsonDateString
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (jsonDateString)
    {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (error)
        {
            NSLog(@"<!> MSJSONDate parsing error: %@", [error localizedDescription]);
        }
        else
        {
            NSTextCheckingResult *match = [regex firstMatchInString:jsonDateString
                                                            options:0
                                                              range:NSMakeRange(0, [jsonDateString length])];
            if (match)
            {
                NSRange dateTimeRange = [match rangeAtIndex:1];
                if (dateTimeRange.location != NSNotFound)
                {
                    NSTimeInterval msFromEpoch = [[jsonDateString substringWithRange:dateTimeRange] doubleValue];
                    [dict setObject:[NSNumber numberWithDouble:msFromEpoch] forKey:MSJSONDateInMilliseconds];
                }
                
                NSRange offsetRange = [match rangeAtIndex:2];
                if (offsetRange.location != NSNotFound)
                {
                    NSInteger offset = [[jsonDateString substringWithRange:offsetRange] integerValue];
                    NSInteger msOffset = ((offset/100)*60 + offset%100) * 60 * 1000;
                    [dict setObject:[NSNumber numberWithDouble:msOffset] forKey:MSJSONTimeZoneOffsetInMilliseconds];
                }
            }
        }
    }
    
    return [dict copy];
}

+ (NSDate *)dateWithJSON:(NSString *)dateTime
{
    NSDate *date;
    
    NSDictionary *dict = [MSJSONDate parseString:dateTime];
    NSNumber *dateMilliseconds = [dict objectForKey:MSJSONDateInMilliseconds];
    
    if (dateMilliseconds)
    {
        NSTimeInterval secondsFromEpoch = [dateMilliseconds doubleValue]/1000.0;
        date = [NSDate dateWithTimeIntervalSince1970:secondsFromEpoch];
    }
    
    return date;
}

+ (NSTimeZone *)timeZoneWithJSON:(NSString *)dateTime
{
    NSTimeZone *zone;
    
    NSDictionary *dict = [MSJSONDate parseString:dateTime];
    NSNumber *offsetMilliseconds = [dict objectForKey:MSJSONTimeZoneOffsetInMilliseconds];
    
    if (offsetMilliseconds)
    {
        NSInteger offsetSeconds = [offsetMilliseconds integerValue] / 1000;
        zone = [NSTimeZone timeZoneForSecondsFromGMT:offsetSeconds];
    }
    
    return zone;
}

+ (NSString *)jsonWithDate:(NSDate *)date
{
    return [self jsonWithDate:date timeZone:nil];
}

+ (NSString *)jsonWithDate:(NSDate *)date appendTimeZone:(BOOL)appendCurrentTimeZone
{
    NSTimeZone *tz = appendCurrentTimeZone ? [NSTimeZone defaultTimeZone] : nil;
    return [self jsonWithDate:date timeZone:tz];
}

+ (NSString *)jsonWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone
{
    NSString *jsonString;
    
    if (date)
    {
        NSString *offset = @"";
        if (timeZone)
        {
            NSInteger minutes = [timeZone secondsFromGMT] / 60;
            NSInteger hours = minutes / 60;
            offset = minutes < 0 ? @"-" : @"+";
            offset = [offset stringByAppendingFormat:@"%02d%02d", ABS(hours), ABS(minutes - hours*60)];
        }
        
        NSTimeInterval seconds = [date timeIntervalSince1970];
        jsonString = [NSString stringWithFormat:@"/Date(%.0f%@)/", seconds * 1000.0, offset];
    }
    
    return jsonString;
}

+ (NSDate *)dateWithOffsetJSON:(NSDictionary *)dateTimeOffset
{
    NSString *dateTime = dateTimeOffset[@"DateTime"];
    return [self dateWithJSON:dateTime];
}

+ (NSTimeZone *)timeZoneWithOffsetJSON:(NSDictionary *)dateTimeOffset
{
    NSTimeZone *tz = nil;
    
    NSString *offsetMinutes = dateTimeOffset[@"OffsetMinutes"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:offsetMinutes];
    if (number) {
        NSInteger seconds = [offsetMinutes integerValue] * 60;
        tz = [NSTimeZone timeZoneForSecondsFromGMT:seconds];
    }
    
    return tz;
}

+ (NSDictionary *)offsetJSONWithDate:(NSDate *)date
{
    return [self offsetJSONWithDate:date timeZone:[NSTimeZone defaultTimeZone]];
}

+ (NSDictionary *)offsetJSONWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone
{
    NSMutableDictionary *dateDict = [NSMutableDictionary new];
    if (date)
    {
        [dateDict setObject:[date jsonValue] forKey:@"DateTime"];
    }
    if (timeZone)
    {
        NSInteger minutesFromGMT = [timeZone secondsFromGMT] / 60;
        [dateDict setObject:[NSString stringWithFormat:@"%i", minutesFromGMT] forKey:@"OffsetMinutes"];
    }
    return dateDict;
}

@end


@implementation NSDate (CMJSON)

- (NSString *)jsonValue
{
    return [MSJSONDate jsonWithDate:self];
}

- (NSString *)jsonValueWithCurrentTimeZone
{
    return [MSJSONDate jsonWithDate:self appendTimeZone:YES];
}

- (NSString *)jsonValueWithTimeZone:(NSTimeZone *)timeZone
{
    return [MSJSONDate jsonWithDate:self timeZone:timeZone];
}

- (NSDictionary *)offsetJSONValue
{
    return [MSJSONDate offsetJSONWithDate:self];
}

- (NSDictionary *)offsetJSONValueWithTimeZone:(NSTimeZone *)timeZone
{
    return [MSJSONDate offsetJSONWithDate:self timeZone:timeZone];
}

@end
