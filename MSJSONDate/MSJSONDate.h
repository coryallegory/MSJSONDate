//  MSJSONDate.h
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


#import <Foundation/Foundation.h>


#pragma mark - Class Methods

/**
 *  MSJSONDate is used to parse and generate datetime strings encoded using Microsoft JSON formats:
 *
 *  1.  `/Date(1198908717056)/`
 *
 *  2.  `/Date(1198908717056+0500)/`
 *
 *  3.  `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 */

@interface MSJSONDate : NSObject {}

#pragma mark DataTime format

/**
 *  Parses a JSON formatted date string and generates a corresponding dictionary of values.
 *
 *  @param string   JSON string to parse for date and time values
 *  @return         Dictionary of parsed JSON values
 */
+ (NSDictionary *)parseString:(NSString *)string;

/**
 *  Parses a JSON formatted date string and generates a corresponding NSDate instance.
 *
 *  @param dateTime JSON string to parse for date value
 *  @return         NSDate instance corresponding to dateTime,
 *                  nil if unrecognized string format
 */
+ (NSDate *)dateWithJSON:(NSString *)dateTime;

/**
 *  Parses a JSON formatted date string for a timezone offset value and generates
 *  a corresponding NSTimeZone instance.
 *
 *  @param dateTime JSON string to parse for timezone value
 *  @return         NSTimeZone instance corresponding to dateTime,
 *                  nil if unrecognized string format or timezone suffix not found
 */
+ (NSTimeZone *)timeZoneWithJSON:(NSString *)dateTime;

/**
 *  Generate a JSON string element using the Microsoft format
 *
 *      `/Date(1198908717056)/`
 *
 *  @param date     NSDate to be converted to JSON string
 *  @return         JSON string element, nil if date parameter is nil
 */
+ (NSString *)jsonWithDate:(NSDate *)date;

/**
 *  Generate a JSON string element using the Microsoft format with current timezone offset
 *
 *      `/Date(1198908717056+0500)/`
 *
 *  @param date     NSDate to be converted to JSON string
 *  @param appendCurrentTimeZone  Specify whether or not to include timeZone information in the JSON value
 *  @return         JSON string element, nil if date parameter is nil
 */
+ (NSString *)jsonWithDate:(NSDate *)date appendTimeZone:(BOOL)appendCurrentTimeZone;

/**
 *  Generate a JSON string element using the Microsoft format with timezone offset
 *
 *      `/Date(1198908717056+0500)/`
 *
 *  If timezone is nil, offset is not omitted.
 *
 *  @param date     NSDate to be converted to JSON string
 *  @param timeZone NSTimeZone used to calculate offset value
 *  @return         JSON string element, nil if date parameter is nil
 */
+ (NSString *)jsonWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone;


#pragma mark DateTimeOffset format

 /**
 *  Parses a JSON object of the Microsft DateTimeOffset format, and generates a corresponding NSDate element
 *
 *  Expected format:
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  @param dateTimeOffset   JSON object with DateTimeOffset key-value pairs
 *  @return                 NSDate corresponding to dateTimeOffset, nil if DateTime key not found or invalid
 */
+ (NSDate *)dateWithOffsetJSON:(NSDictionary *)dateTimeOffset;

/**
 *  Parses a JSON object of the Microsft DateTimeOffset format, and generates a corresponding NSTimeZone element
 *
 *  Expected format:
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  @param dateTimeOffset   JSON object with DateTimeOffset key-value pairs
 *  @return                 NSTimeZone corresponding to dateTimeOffset,
 *                          nil if OffsetMinutes key not found or invalid
 */
+ (NSTimeZone *)timeZoneWithOffsetJSON:(NSDictionary *)dateTimeOffset;

/**
 *  Generate a JSON object of key value pairs using the Microsoft DateTimeOffset format as follows:
 *
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  The current timezone is used to calculate the OffsetMinutes value.
 *
 *  Unrecognized or unexpected values will be omitted from the generated JSON object.
 *
 *  Dictionary contains the following key-value pairs,
 *      MSJSONDateInMilliseconds:           Datetime in milliseconds since epoch
 *      MSJSONTimeZoneOffsetInMilliseconds: Timezone offset in milliseconds from GMT
 *
 *  @param date NSDate from which the JSON values will be generated
 *  @return     JSON object with values corresponding to date and the current timezone
 */
+ (NSDictionary *)offsetJSONWithDate:(NSDate *)date;

/**
 *  Generate a JSON object of key value pairs using the Microsoft DateTimeOffset format as follows:
 *
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  Unrecognized or unexpected values will be omitted from the generated JSON object.
 *
 *  Dictionary contains the following key-value pairs,
 *      MSJSONDateInMilliseconds:           Datetime in milliseconds since epoch
 *      MSJSONTimeZoneOffsetInMilliseconds: Timezone offset in milliseconds from GMT
 *
 *  @param date     NSDate from which the JSON values will be generated
 *  @param timeZone NSTimeZone from which the JSON values will be generated
 *  @return         JSON object with values corresponding to parameters
 */
+ (NSDictionary *)offsetJSONWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone;


#pragma mark Constants

/**
 *  NSDictionary keys for parsed JSON values
 */

/**
 *  MSJSONDateInMilliseconds
 *
 *  Key for datetime value expressed in milliseconds since epoch.
 *
 *      `extern NSString *const MSJSONDateInMilliseconds;`
 */
extern NSString *const MSJSONDateInMilliseconds;

/**
 *  MSJSONTimeZoneOffsetInMilliseconds
 *
 *  Key for timezone offset expressed as milliseconds from GMT.
 *
 *      `extern NSString *const MSJSONTimeZoneOffsetInMilliseconds;`
 */
extern NSString *const MSJSONTimeZoneOffsetInMilliseconds;

@end


#pragma mark - Category Methods

@interface NSDate (MSJSONDate) {}

#pragma mark DateTime format

/**
 *  Generate a JSON string element using the Microsoft format
 *
 *      `/Date(1198908717056)/`
 *
 *  @return JSON string element
 */
- (NSString *)jsonValue;

/**
 *  Generate a JSON string element using the Microsoft format with current timezone offset
 *
 *      `/Date(1198908717056+0500)/`
 *
 *  @return JSON string element
 */
- (NSString *)jsonValueWithCurrentTimeZone;

/**
 *  Generate a JSON string element using the Microsoft format with timezone offset
 *
 *      `/Date(1198908717056+0500)/`
 *
 *  If timezone is nil, offset is omitted.
 *
 *  @param timeZone NSTimeZone used to calculate offset value
 *  @return         JSON string element
 */
- (NSString *)jsonValueWithTimeZone:(NSTimeZone *)timeZone;


#pragma mark DateTimeOffset format

/**
 *  Generate a JSON object of key value pairs using the Microsoft DateTimeOffset format as follows:
 *
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  The current timezone is used to calculate the OffsetMinutes value.
 *
 *  Dictionary contains the following key-value pairs,
 *      MSJSONDateInMilliseconds:           Datetime in milliseconds since epoch
 *      MSJSONTimeZoneOffsetInMilliseconds: Timezone offset in milliseconds from GMT
 *
 *  @return     JSON object with values corresponding to date and the current timezone
 */
- (NSDictionary *)offsetJSONValue;

/**
 *  Generate a JSON object of key value pairs using the Microsoft DateTimeOffset format as follows:
 *
 *      `{
 *          DateTime: "/Date(1198908717056)/",
 *          OffsetMinutes: "-360"
 *      }`
 *
 *  Unrecognized or unexpected timezone values will be omitted from the generated JSON object.
 *
 *  Dictionary contains the following key-value pairs,
 *      MSJSONDateInMilliseconds:           Datetime in milliseconds since epoch
 *      MSJSONTimeZoneOffsetInMilliseconds: Timezone offset in milliseconds from GMT
 *
 *  @param timeZone NSTimeZone from which the JSON values will be generated
 *  @return         JSON object with values corresponding to parameters
 */
- (NSDictionary *)offsetJSONValueWithTimeZone:(NSTimeZone *)timeZone;

@end
