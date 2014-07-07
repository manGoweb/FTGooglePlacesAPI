#FTGooglePlacesAPI

An open-source iOS Objective-C library for querying [Google Places API][1] using simple callback-blocks based interface.

Perform Google Places API requests with ease in a few lines of code. Library includes, but is not limited to, following:

 - [Place Search][2]
     - Nearby Search (search places withing a specified area)
     - Text Search (search places based on a search string)
 - [Place Details][3] (get more comprehensive information about a place)

<table>
  <tr>
    <td>
       <a href="http://i.imgur.com/DGMbcw1.png">
          <img src="http://i.imgur.com/DGMbcw1.png" width="200" alt="FTGooglePlacesAPI example screenshot"/>
       </a>
    </td>
    <td>
       <a href="http://i.imgur.com/1POEIRN.png">
          <img src="http://i.imgur.com/1POEIRN.png" width="200" alt="FTGooglePlacesAPI example screenshot"/>
       </a>
    </td>
    <td>
       <a href="http://i.imgur.com/ATk5qhR.png">
          <img src="http://i.imgur.com/ATk5qhR.png" width="200" alt="FTGooglePlacesAPI example screenshot"/>
       </a>
    </td>
  </tr>
</table>

##Instalation

### CocoaPods

*FTGooglePlacesAPI* is available as a CocoaPod

    pod 'FTGooglePlacesAPI'

### Manual (or using git submodule)
 1. Implement [AFNetworking 2.0][4]
    - FTGooglePlacesAPI uses AFNetworking 2.0 for all of its networking. Why? Because it rocks!
 2. Download source files from this repository
    - Or use GIT submodule ( `git submodule add git@github.com:FuerteInternational/FTGooglePlacesAPI.git` )
 3. Add all files from *FTGooglePlacesAPI* folder to your project's target

##Usage

You can take a look at the detailed example usage project *XcodeProject/FTGooglePlacesAPI.xcodeproj*. Just be sure to provide your own API key. Or dive in yourself following these few steps...

#### 1. Import FTGooglePlacesAPI files in your implementation file
```objective-c
#import "FTGooglePlacesAPI.h"
```

#### 2. Setup service

In order to communicate with a Google Places API, you must first generate your own API key which you can get at [Google Play Developer Console][5]. You can also take a look at [Introduction - Google Places API][6].

You must provide API key to a `FTGooglePlacesAPI` service before making any request using it. Good place for this code is the App Delegate.

```objective-c
//  Provide API key to FTGooglePlacesAPIService before making any requests
[FTGooglePlacesAPIService provideAPIKey:@"YOUR_API_KEY"];
```

Optionaly, you can enable debug logging. If this is set to `YES` and when building in debug mode (`#ifdef DEBUG`), service will print some debugging information to the console. In fact there is no need to remove this code even from Release build since the service will not produce any output in non-debug builds.

```objective-c
//  Optionally enable debug mode
[FTGooglePlacesAPIService setDebugLoggingEnabled:YES];
```

#### 3. Create a request

Construct a desired request.

```objective-c
//  Create location around which to search (hardcoded location of Big Ben here)
CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(51.501103,-0.124565);

//  Create request searching nearest galleries and museums
FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:locationCoordinate];
request.rankBy = FTGooglePlacesAPIRequestParamRankByDistance;
request.types = @[@"art_gallery", @"museum"];
```

There is a lot of possibilities since the implemented requests objects supports all of the API's functionality. See the example project and the [Google Places API documentation][7].

**Tip**: You can determine user's current location very easily using [FTLocationManager][8].

#### 4. Perform request and handle the results

```objective-c
//  Execute Google Places API request using FTGooglePlacesAPIService
[FTGooglePlacesAPIService executeSearchRequest:request
                         withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
                             
     //  If error is not nil, request failed and you should handle the error
     if (error)
     {
         // Handle error here
         NSLog(@"Request failed. Error: %@", error);
         
         //  There may be a lot of causes for an error (for example networking error).
         //  If the network communication with Google Places API was successfull,
         //  but the API returned some non-ok status code, NSError will have
         //  FTGooglePlacesAPIErrorDomain domain and status code from
         //  FTGooglePlacesAPIResponseStatus enum
         //  You can inspect error's domain and status code for more detailed info
     }

     //  Everything went fine, we have response object we can process
     NSLog(@"Request succeeded. Response: %@", response);
}];
```

You must use the proper method based on a request type you want to perform because the service will construct the response objects based on a method being called.

Available methods are:

 - `+ (void)executeSearchRequest:withCompletionHandler:` for a both *Nearest* and *Text Search* requests
 - `+ (void)executeDetailRequest:withCompletionHandler:` for a *Place Detail* request

##Compatibility

 - iOS 6+
    - Mainly because of a dependency on AFNetworking 2.0 (although it shouldn't be difficult for you to remove dependency on it)
 - ARC

##Contact

FTGooglePlacesAPI is developed by [Fuerte International](http://fuerteint.com). Please [drop us an email](mailto:open-source@fuerteint.com) to let us know you how you are using this component.

##Contributing and notes

 - If you like the library, please consider giving it a Github star to let us know it.
 - All header files are heavily commented in format compatible with Xcode 5 quick docs preview (Option + Click)
 - Library is unit tested using Apple's *XCTest* and [OCMock](http://ocmock.org/)

Pull requests are very welcome expecting you follow few rules:

 - Document your changes in a code comments and Git commit message
 - Make sure your changes didn't cause any trouble using included example project, unit tests and if appropriate, implement unit tests and example code for your newly added functionality

##Version history

#### 1.1
 - Implemented deprecations for usage of `id` and `reference` properties as these has been deprecated by Google as of June 24, 2014. See [Deprecation notice in documentation](https://developers.google.com/places/documentation/details#deprecation) for more info.

#### 1.0
 - First official public release

##License
```
The MIT License (MIT)

Copyright (c) 2013-2014 Fuerte International

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

```


  [1]: https://developers.google.com/places/documentation/
  [2]: https://developers.google.com/places/documentation/search
  [3]: https://developers.google.com/places/documentation/details
  [4]: https://github.com/AFNetworking/AFNetworking
  [5]: https://code.google.com/apis/console
  [6]: https://developers.google.com/places/documentation/#Authentication
  [7]: https://developers.google.com/places/documentation
  [8]: https://github.com/FuerteInternational/FTLocationManager