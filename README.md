# Neolight
The standard german keyboard layout sucks for programming.
For example `[` is `AltGr+8`, which requires contorting your hand in unspeakable ways.
There is also this beautiful layout called [Neo], which has, among other things, a whole layer with every special character a programmer's heart desires—arranged in an easy to reach fashion.
But Neo rearranges all the other keys too.
Which is good for ergonomics, but also has the downside of messed up shortcuts in various applications and needing to learn a whole new layout.

Neolight tries to solve both problems by adding a third (and forth) layer, while keeping the standard qwertz layout intact as far as possible.
* The third layer is activated by `Capslock` and `#` and contains special characters needed for programming.
* The fourth layer is activated by `<` and `Menu` and contains navigation keys.

All other keys stay the same. In fact, Neolight is not necessarily tied to the german layout and you can use it in combination with any other layout, provided your physical keyboard has the right set of keys.

[Neo]: https://www.neo-layout.org/


## The Layout
### Layer 3
<img src="images/layer3.svg?raw=true" height="200px">

### Layer 4
<img src="images/layer4.svg?raw=true" height="200px">


### Variant with additional escape keys
There is also a variant that has additional escape keys, which are convenient in Vim.
They are located at:
* `Mod3+q`
* `+` on the standard german layout (the key above the right Mod3 in the image above)
* `Mod3++`


## Installation and Usage
### Linux
On Arch Linux Neolight is available as an [AUR package here][AUR].

On other Linux distributions you can install it by running `./linux/install.sh` as superuser. (And `./linux/install.sh --uninstall` for removing it again.)

Depending on your desktop environment you might need to log out and in again (or restart) for it to be fully available.

For activating it there are two options:

[AUR]: https://aur.archlinux.org/packages/neolight


#### As separate layout (only german)
Neolight will show up in the german layout variants as "German (Neolight)".

If the new layers do not work properly and you have multiple layouts, make sure to set Neolight as the first one. Some other ways to fix that problem are mentioned in the [Neo FAQ].

[Neo FAQ]: https://neo-layout.org/Probleme/FAQ/#die-vierte-ebene-funktioniert-nicht-wenn-neo-als-zweitlayout-eingestellt-ist


#### As xkb option (compatible with other layouts)

Neolight can be added to any keyboard layout using the `neolight` or `neolight:escape_keys` xkb options.

In Gnome this is done by adding it to the `dconf` key at `/org/gnome/desktop/input-sources/xkb-options`.
Add it to the list as `'neolight'` or `'neolight:escape_keys'`.
The [dconf-editor] utility helps with that.

[dconf-editor]: https://man.archlinux.org/man/dconf-editor.1


### Windows
The Windows version uses [Autohotkey]. You can either install Autohotkey and run `neolight.ahk`, or run the compiled `neolight.exe` directly.
Both can be found on the release page (coming soon).
Then just add it to autostart.

Similar to the linux xkb option version above, this just adds the layers on top of any existing layout, no matter which.

[Autohotkey]: https://www.autohotkey.com/

## How to Learn
For typing practice have a look at e.g. [typing.io], which lets you type open source code instead of just regular text.

[typing.io]: http://typing.io/lessons

## Alternatives
Neo has a variant called [NeoQwertz] that tries to do something similar: it has all the features of Neo, but keeps the alphabetic keys from qwertz.
This does mean that e.g. `Shift+2` does not produce `"` and no regular `AltGr` layer.
But if that is fine for you, you might want to just go ahead and use NeoQwertz (which comes preinstalled with X11 on most linux distributions!).

[NeoQwertz]: https://www.neo-layout.org/Layouts/neoqwertz/
