MSJSONDate
==========

Cocoa library used to parse and generate date strings encoded using Microsoft JSON formats.

There are three general formats supported,

1. DateTime without offset data

    `"/Date(1198908717056)/"`

2. DateTime with offset data

    `"/Date(1198908717056+0500)/"`

3. DateTimeOffset

    ```
    {
        DateTime: "/Date(1198908717056)/",
        OffsetMinutes: "-360"
    }
    ```


### Usage

Operations can take place using either the MSJSONDate class methods, or the MSJSONDate category for NSDate instances.

Example snippet:

    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    id dateElement = json[@"DateLastModified"];
    NSDate *date = [MSJSONDate dateWithJSON:dateElement];

Example snippet:

    NSDate *date = [NSDate date];
    NSMutableDictionary *jsonElement = [NSMutableDictionary new];
    [jsonElement setObject:[date jsonValue] forKey:@"DateLastModified"];


### Installation

- [Download MSJSONDate](https://github.com/coryallegory/CMJSON/zipball/master)
- Unzip and import the MSJSONDate subdirectory into your Xcode project.
- Simply `#import "MSJSONDate.h"` in your implementation files to get started.


### License

MSJSONDate was created by Cory Metcalfe ([coryallegory](https://github.com/coryallegory)), and is available under the MIT license. See the [LICENSE](https://github.com/coryallegory/MSJSONDate/blob/master/MSJSONDate/LICENSE) file for more info.
