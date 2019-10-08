# Versioning

Track which versions of an iOS a user has previously installed.  

## API Usage

Call this on each app launch inside `didFinishLaunchingWithOptions:`

```swift
Version.track ()
```

Then call these whenever you want (in these examples the user has launched a bunch of previous versions, and this is the first time he's launched the new version 1.0.11):

```swift
Version.firstLaunchEver        // false
Version.firstLaunchForVersion  // true
Version.firstLaunchForBuild    // true

Version.currentVersion         // 1.0.11
Version.previousVersion        // 1.0.10
Version.firstInstalledVersion  // 1.0.0
Version.versionHistory         // [ 1.0.0, 1.0.1, 1.0.2, 1.0.3, 1.0.10, 1.0.11 ]

Version.currentBuild           // 18
Version.previousBuild          // 15
Version.firstInstalledBuild    // 1
Version.buildHistory           // [ 1, 2, 3, 4, 5, 8, 9, 10, 11, 13, 15, 18 ]
 ```

Or set up actions to be called on the first lauch of a specific version or build:

```swift
Version.onFirstLaunch(forBuild: "18") { print("First time Build 18 launched!") }
Version.onFirstLaunch(forVersion: "1.0.11") { print("First time Version 1.0.11 launched!") }
```


## Contributors

Made with ❤️ by  [Colby Williams](https://github.com/colbylwilliams)
  
 _Originally inspired by [GBVersionTracking](https://github.com/lmirosevic/GBVersionTracking), which I wrote a [Xamarin version](https://github.com/colbylwilliams/VersionTrackingPlugin) for, and ported that to Swift_


#### License
The MIT License (MIT)
Copyright © 2019 Colby Williams
