# FinderMenu

Adds submenu to the context menu of Mac OS X Finder. Submenu has two items, clicking on them the window with the selected items is displayed.

## Description

The method `configureWithNodes:browserController:container:` of class `TContextMenu` is called, when Finder is going to show context menu on files. This method is replaced, using the [*MethodSwizzle*](http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html) technique.

`mach_inject` is used to inject code into the Finder process.

The application consists of the following components:

* *FinderMenu* - the injector app, that loads bundle into Finder
* *FinderExt.bundle* - injectee bundle, that overrides code inside Finder process
* *mach_inject_bundle.framework* (and *mach_inject_bundle_stub.bundle* which is part of this framework) - mach inject bundle framework, which used by *FinderMenu*

Application has only been tested on the latest version of Mac OS X 10.8.2. I will be grateful if you test it in earlier versions. Theoretically it should work on OS X versions >= 10.6 (in 10.6 Finder has been rewritten from Carbon to Cocoa and this hack is Cocoa-specific).

## Building & running

Application is required `procmod` group permssion, so you can not just run it in Xcode. To build it in Terminal you can use `xcodebuild` tool. After building you can just run it with `sudo`, or change executable group to `procmod` and `setgid` bit on it.
