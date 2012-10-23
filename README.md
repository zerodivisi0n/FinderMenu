# FinderMenu

Adding items into context menu in Mac OS X Finder

## Description

Finder's method `buildContextMenu:forContext:browserController:maxItems:addServices:` of class `TContextMenu` is responsible for menu creation. So `mach_inject` is used to inject code into Finder process and `mach_override` to override code inside the process.

The application consists of the following components:

* *FinderMenu* - the injector app, that loads bundle into Finder
* *FinderExt.bundle* - injectee bundle, that overrides code inside Finder process
* *mach_inject_bundle.framework* (and *mach_inject_bundle_stub.bundle* which is part of this framework) - mach inject bundle framework, which used by *FinderMenu*

Application has only been tested on the latest version of Mac OS X 10.8.2. I will be grateful if you test it in earlier versions. Theoretically it should work on OS X versions >= 10.6 (in 10.6 Finder has been rewritten from Carbon to Cocoa and this app is Cocoa-specific).

## Building & running

Application is required `procmod` group permssion, so you can not just run it in Xcode. To build it in Terminal you can use `xcodebuild` tool. After building you can just run it with `sudo`, or change executable group to `procmod` and `setgid` bit on it.

## TODO

For now the application simply adds items to the context menu and there is no way to determine which item was selected. The next step is to figure out how to do it.