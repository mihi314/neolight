# Neolight
The standard German keyboard layout sucks for programming.
For example `[` is `AltGr+8`, which requires contorting your hand in unspeakable ways.
There is also this beautiful layout called [Neo], which has, among other things, a whole layer with every special character a programmer's heart desires—arranged in an easy to reach fashion.
However, Neo rearranges all the other keys too.
Which is good for ergonomics, but has the downside of messed up shortcuts in various applications and needing to learn a whole new layout.

Neolight tries to make the best of both worlds by adding a third (and fourth) layer, while keeping the standard qwertz layout intact as far as possible.
* The third layer is activated by `Capslock` and `#` and contains special characters needed for programming.
* The fourth layer is activated by `<` and `Menu` and contains navigation keys.

All other keys stay the same. In fact, Neolight is not necessarily tied to the German layout and you can use it in combination with any other layout, provided your physical keyboard has the right set of keys.

[Neo]: https://www.neo-layout.org/


## The Layout
### Layer 3
<img src="images/layer3.png?raw=true" width="600px">

### Layer 4
<img src="images/layer4.png?raw=true" width="600px">

### Locking
The old capslock behavior is still available via `Alt+Capslock`.
Similar to that, layer 4 can be locked via `Alt+Mod4`.

### Variant with additional escape keys
There is also a variant that has additional escape keys, which are convenient in Vim.
They are located at:
* `Mod3+q`
* `+` on the standard German layout (the key above the right Mod3 in the image above)
* `Mod3++`


## Installation and Usage
### Linux

On Arch Linux Neolight is available as an [AUR package here][AUR].

On other Linux distributions you can install it by running `./linux/install.sh` as superuser (and `./linux/install.sh --uninstall` for removing it again). Depending on your desktop environment you might need to log out and in again (or restart) for it to be fully available.

This will add the following XKB layout and options:

[AUR]: https://aur.archlinux.org/packages/neolight

* **XKB layout (only German)**

    The standalone layout is called `neolight`, which also has a variant called `de_escape_keys`. They can be (temporarily) activated via:
    ```
    setxkbmap -layout neolight -variant de
    setxkbmap -layout neolight -variant de_escape_keys
    ```

    To check the current XKB config:
    ```
    setxkbmap -query
    ```

* **XKB options (compatible with other layouts)**

    The XKB options can be combined with any keyboard layout and add the third and fourth layer to them. They are called `neolight` and `neolight:escape_keys` and can be (temporarily) activated via:

    ```
    setxkbmap -option neolight
    setxkbmap -option neolight:escape_keys
    ```


Activating the layout or an option more permanently depends on your system:

#### Gnome
Neolight should show up in the German layout variants as "German (Neolight)".
If not, enable the "Show Extended Input Sources" option in the Gnome Tweaks tool.

If the new layers do not work properly and you have multiple layouts, make sure to set Neolight as the first one. Some other ways to fix that particular problem are mentioned in the [Neo FAQ].

To set one of the options, use Gnome Tweaks (Keyboard -> Additional Layout Options -> Neolight).
Alternatively, you can add them by hand to the `dconf` key at `/org/gnome/desktop/input-sources/xkb-options` as `['neolight', ... other options]` or `['neolight:escape_keys', ... other options]`.
The [dconf-editor] utility helps with that.

Note: These options only work for the first layout, should you have multiple. There are [ways around this][groups-issue], but I have not added them yet.

[Neo FAQ]: https://neo-layout.org/Probleme/FAQ/#die-vierte-ebene-funktioniert-nicht-wenn-neo-als-zweitlayout-eingestellt-ist
[dconf-editor]: https://man.archlinux.org/man/dconf-editor.1
[groups-issue]: https://github.com/xkbcommon/libxkbcommon/issues/97#issuecomment-500115821

#### IBus
Neolight should show up in the IBus Preferences (`ibus-setup`) as "German (Neolight)".

I haven't found a way to set individual XKB options there. A workaround would be setting "Use system keyboard layout" and configuring the XKB layout/options in a different way.

#### Others
If Neolight is missing from your layout selector, let me know and I'll try to add support for it.


### Windows
The Windows version uses [AutoHotkey]. You can either install AutoHotkey and run `neolight.ahk`, or run the compiled `neolight.exe` directly.
Both can be found on the release page.
Then just add it to autostart.

Similar to the linux XKB option version above, this just adds the layers on top of any existing layout, no matter which.

[AutoHotkey]: https://www.autohotkey.com/

## How to Learn
If you want some typing practice, have a look at [typing.io], which lets you type open source code instead of just regular text.
Another one is [keybr.com], which also has a source code mode, but also adapts the lessons based on which keys you struggle with.

[typing.io]: http://typing.io/lessons
[keybr.com]: https://www.keybr.com

## Alternatives
Neo has a variant called [NeoQwertz] that tries to do something similar: it has all the features of Neo, but keeps the alphabetic keys from qwertz.
This does mean that e.g. `Shift+2` does not produce `"` and no regular `AltGr` layer.
But if that is fine for you, you might want to just go ahead and use NeoQwertz (which comes preinstalled with X11 on most linux distributions!).

[NeoQwertz]: https://www.neo-layout.org/Layouts/neoqwertz/
