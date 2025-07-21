//
//  AppDelegate.swift
//  vintagestory
//
//  Created by Jacopo Uggeri on 21/07/2025.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var didHandleURL = false

    // Handle custom URL scheme launches
    func application(_ application: NSApplication, open urls: [URL]) {
        didHandleURL = true
        // Only handle the first URL
        if let url = urls.first {
            launchVintagestory(with: url.absoluteString)
        }
        // Optional: exit the wrapper app after launching the target
        NSApp.terminate(nil)
    }

    // Handle normal launches
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !didHandleURL {
            launchVintagestory(with: nil)
            NSApp.terminate(nil)
        }
    }

    private func launchVintagestory(with url: String?) {
        let appPath = (Bundle.main.resourcePath! as NSString).appendingPathComponent("vintagestory.app/Vintagestory")
        print("DEBUG: About to launch Vintagestory")
        print("DEBUG: Computed appPath: \(appPath)")

        let fileManager = FileManager.default
        if !fileManager.isExecutableFile(atPath: appPath) {
            print("ERROR: Executable not found or not executable at \(appPath)")
        }
        
        let task = Process()
        task.launchPath = appPath
        if let url = url {
            print("DEBUG: Launching with URL: \(url)")
            task.arguments = ["-i", url]
        } else {
            print("DEBUG: Launching with no URL argument")
        }
        
        var env = ProcessInfo.processInfo.environment
        let dotnetPath = "/usr/local/share/dotnet"
        if let path = env["PATH"] {
            if !path.contains(dotnetPath) {
                env["PATH"] = "\(dotnetPath):\(path)"
            }
        } else {
            env["PATH"] = dotnetPath
        }
        env["DOTNET_ROOT"] = dotnetPath

        print("DEBUG: Final PATH: \(env["PATH"] ?? "<not set>")")
        print("DEBUG: Final DOTNET_ROOT: \(env["DOTNET_ROOT"] ?? "<not set>")")

        task.environment = env

        do {
            print("DEBUG: Attempting to run the task…")
            try task.run()
            print("DEBUG: Task launched successfully!")
        } catch {
            print("Failed to launch Vintagestory: \(error)")
        }
    }


}

