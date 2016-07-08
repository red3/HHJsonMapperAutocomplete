# HHJsonMapperAutocomplete [![Build Status](https://api.travis-ci.org/red3/HHJsonMapperAutocomplete.svg)](https://travis-ci.org/red3/HHJsonMapperAutocomplete.svg) 
---

## What is this?

You need to write custom JsonModel keypaths no matter what kind of JsonModel you are using, such as [YYModel](https://github.com/ibireme/YYModel), [Mantle](https://github.com/Mantle/Mantle), [jsonModel](https://github.com/jsonmodel/jsonmodel), etc. But it is really painful writing these code by yourself. Think about how much time you are wasting in copy a property in your interface file, and typing the property in the implementation file again and again. Now, you can find the method (or any code) you want to document to, and type in `???`, the JsonModel keypaths will be generated for you.

Here is an image which can show what it exactly does. 

![Screenshot](https://raw.github.com/red3/HHJsonMapperAutocomplete/master/ScreenShot.gif)

## How to install and use?

The best way of installing is by [Alcatraz](http://alcatraz.io). Install Alcatraz followed by the instruction, restart your Xcode and press `⇧⌘9`. You can find `HHJsonMapperAutocomplete` in the list and click the icon on left to install.

If you do not like the Alcatraz way, you can also clone the repo. Then build the `HHJsonMapperAutocomplete` target in the Xcode project and the plug-in will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. Relaunch Xcode and type in `???` above any code you want to write a document to.

If you want to use other text beside of `???` to trigger the JsonModel keypaths insertion, you can find a setting panel by clicking `HHJsonMapperAutocomplete` in the Window menu of Xcode. You can also find some other useful options there, including setting using other JsonModel to be your default one or just using your costom mapper method instand.

## Xcode version?

This plug-in is supported in Xcode 5, 6 and 7. From Xcode 5, Apple added a UUID-verification to all plugins to ensure the stability when Xcode gets updated. The value of `DVTPlugInCompatibilityUUIDs` in project plist should contains current UUID of Xcode version, or the plugin does not work. And from Xcode 6.3, you will be prompt to "Load third party bundle" if you are using a plugin. You should always select "Load bundles" to enable this plugin.

All plugins will be disabled once you update your Xcode, since the supported UUIDs in the plugins do not contain the one. You should try to clean your plugins folder (`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` by default) and clone/build the latest version from master branch. If you happened to skip the bundle loading, you can use this to reset the prompt:

```bash
defaults delete com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-{your_xcode_version}
```

**Please do not open an issue if this plugin not work in your newly updated Xcode.** Pull request for new `DVTPlugInCompatibilityUUIDs` is welcome, and if UUID of your Xcode version is already there, please try to reinstall the plugin from a clean state.

The default deployment target is 10.8. If you want to use it in a earlier OS version, you should change OS X Deployment Target (in project info setting) to your system version.

## Swift Support

Coming Soon!

## Limitations and Future

The plugin is using simulation of keyboard event to insert the doc comments for you. So it is depending the keyboard shortcut of Xcode. These two kinds of operation are being used:

* Delete to Beginning of the Line (⌘⌫)
* Paste (⌘V)

If you have modified these two shortcuts in your Xcode, the newset version of the plugin would not work correctly. 

## License

VVDocumenter is published under MIT License. See the LICENSE file for more.

