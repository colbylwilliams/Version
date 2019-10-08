//
//  Versioning.swift
//  Versioning
//
//  Created by Colby L Williams on 10/7/19.
//  Copyright © 2019 Colby L Williams. All rights reserved.
//

import Foundation

public struct Version {
    
    #if DEBUG
    public static func reset() {
        UserDefaults.standard.removeObject(forKey: versionTrailKey)
    }
    #endif
    
    fileprivate static var trackCalled = false
    
    fileprivate static var versionTrail: [String:[String]] = [:]
    
    fileprivate static let buildsKey = "com.colbylwilliams.version.builds"
    fileprivate static let versionsKey = "com.colbylwilliams.version.versions"
    fileprivate static let versionTrailKey = "com.colbylwilliams.version.version.trail"
    
    fileprivate static var _firstLaunchEver = false
    fileprivate static var _firstLaunchForVersion = false
    fileprivate static var _firstLaunchForBuild = false

    public static var firstLaunchEver: Bool {
        get {
            assert(trackCalled, "You must call Version.track() before accessing this property")
            return _firstLaunchEver
        }
        set { _firstLaunchEver = newValue }
    }
    
    public static var firstLaunchForVersion: Bool {
        get {
            assert(trackCalled, "You must call Version.track() before accessing this property")
            return _firstLaunchForVersion
        }
        set { _firstLaunchForVersion = newValue }
    }
    
    public static var firstLaunchForBuild: Bool {
        get {
            assert(trackCalled, "You must call Version.track() before accessing this property")
            return _firstLaunchForBuild
        }
        set { _firstLaunchForBuild = newValue }
    }
    
    public static func track() {
        
        var needsSync = false
        
        // load history
        if let oldVersionTrail = UserDefaults.standard.dictionary(forKey: versionTrailKey) as? [String:[String]],
            let _ = oldVersionTrail[buildsKey], let _ = oldVersionTrail[versionsKey] {
            
            firstLaunchEver = false
            
            versionTrail = oldVersionTrail
            needsSync = true
            
        } else {
            
            firstLaunchEver = true
            
            versionTrail = [
                buildsKey: [],
                versionsKey: []
            ]
        }

        trackCalled = true
        
        // check if this build was previously launched
        firstLaunchForBuild = !versionTrail[buildsKey]!.contains(currentBuild)
        
        if firstLaunchForBuild {
            versionTrail[buildsKey]!.append(currentBuild)
            needsSync = true
        }
        
        // check if this version was previously launched
        firstLaunchForVersion = !versionTrail[versionsKey]!.contains(currentVersion)
        
        if firstLaunchForVersion {
            versionTrail[versionsKey]!.append(currentVersion)
            needsSync = true
        }
        
        // store the new version stuff
        if needsSync {
            UserDefaults.standard.set(versionTrail, forKey: versionTrailKey)
        }
    }
    
    public static var currentBuild: String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "unknown"
    }
    
    public static var currentVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
    
    public static var previousBuild: String? {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        let count = versionTrail[buildsKey]?.count ?? 0
        return count >= 2 ? versionTrail[buildsKey]?[count - 2] : nil
    }
    
    public static var previousVersion: String? {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        let count = versionTrail[versionsKey]?.count ?? 0
        return count >= 2 ? versionTrail[versionsKey]?[count - 2] : nil
    }

    public static var firstInstalledBuild: String? {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        return versionTrail[buildsKey]?.first
    }
    
    public static var firstInstalledVersion: String? {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        return versionTrail[versionsKey]?.first
    }

    public static var buildHistory: [String] {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        return versionTrail[buildsKey] ?? []
    }
    
    public static var versionHistory: [String] {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        return versionTrail[versionsKey] ?? []
    }
    
    public static func firstLaunch(forBuild build: String) -> Bool {
        assert(trackCalled, "You must call Version.track() before calling this function")
        return currentBuild == build && firstLaunchForBuild
    }
    
    public static func firstLaunch(forVersion version: String) -> Bool {
        assert(trackCalled, "You must call Version.track() before calling this function")
        return currentVersion == version && firstLaunchForVersion
    }
    
    public static func onFirstLaunch(forBuild build: String, _ callback: (() -> Void)) {
        assert(trackCalled, "You must call Version.track() before calling this function")
        if firstLaunch(forBuild: build) {
            callback()
        }
    }
    
    public static func onFirstLaunch(forVersion version: String, _ callback: (() -> Void)) {
        assert(trackCalled, "You must call Version.track() before calling this function")
        if firstLaunch(forVersion: version) {
            callback()
        }
    }
    
    public static var info: String {
        assert(trackCalled, "You must call Version.track() before accessing this property")
        return """
            Version:
                firstLaunchEver:        \(firstLaunchEver)
                firstLaunchForVersion:  \(firstLaunchForVersion)
                firstLaunchForBuild:    \(firstLaunchForBuild)
                currentBuild:           \(currentBuild)
                currentVersion:         \(currentVersion)
                previousBuild:          \(previousBuild ?? "none")
                previousVersion:        \(previousVersion ?? "none")
                firstInstalledBuild:    \(firstInstalledBuild ?? "unknown")
                firstInstalledVersion:  \(firstInstalledVersion ?? "unknown")
                buildHistory:           [ \(buildHistory.joined(separator: ", ")) ]
                versionHistory:         [ \(versionHistory.joined(separator: ", ")) ]
        """
    }
}
