# rc24.sh
![rc24.sh Screenshot](/images/rc24.sh_Screenshot.png)

rc24.sh is a patcher for RiiConnect24 services, written in Bash. Currently, it is supported on Linux, and will soon support macOS.

rc24.sh is heavily inspired by the [original RiiConnect24 Patcher](https://github.com/RiiConnect24/RiiConnect24-Patcher) for Windows by [KcrPL](https://github.com/KcrPL), so please check that out!

[TheShadowEevee](https://github.com/TheShadowEevee) ported person66's Sharpii to .NET Core, allowing Sharpii to work flawlessly on Unix-like operating systems. Check it out [here](https://github.com/TheShadowEevee/Sharpii-NetCore)!

[KuraiKoroko](https://github.com/KuraiKokoro) is working on a [Python-based RiiConnect24 patcher](https://github.com/KuraiKokoro/RiiConnect24-PyPatcher), with the goal of working on several operating systems, including Windows, macOS, Linux, and even Android!

Finally, please check out the [RiiConnect24 website](https://rc24.xyz/) if you haven't already.

## Credits
* HTV04: rc24.sh developer
* TheShadowEeevee, person66, and leathl: Sharpii-NetCore, Sharpii, and libWiiSharp developers
* KcrPL and Larsenv: RiiConnect24 founders, original RiiConnect24 Patcher developers
* And you!

## Setup
### Linux
* Ensure your device is connected to the internet, as it is needed for rc24.sh to download files.
* If rc24.sh has been downloaded and extracted before, please delete the files of the old version before extracting a new version.
* Extract the release zip for your device (usually amd64) found [here](https://github.com/HTV04/rc24.sh/releases/latest).
* Open a terminal.
  * Install the `curl` and `xdelta3` packages using your default package manager. Please consult your distro's information on installing packages if you are having trouble doing this.
  * Navigate to the folder the files have been extracted to (using `ls` to show the files in the current folder and `cd [folder name here]` to enter a folder).
* Type `chmod +x Sharpii rc24.sh` into the terminal and press return.
* Type `./rc24.sh` into the terminal and press return. rc24.sh will now start.

## Roadmap
* Uninstallation script (and restore unused menus).
* Custom output folder support (instead of Copy-to-SD).
* Support for extra RiiConnect24 services, akin to the original RiiConnect24 Patcher.
* Support for other langauges than English.
