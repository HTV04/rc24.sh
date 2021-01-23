# rc24.sh
![rc24.sh Screenshot](/images/rc24.sh_Screenshot.png)

rc24.sh is a patcher and manager for RiiConnect24 services, written in Bash. Currently, it is supported on Linux, and will soon support macOS.

## Setup
### Linux
* Ensure your device is connected to the internet, as it is needed for rc24.sh to download files.
* If rc24.sh has been downloaded and extracted before, please delete the files of the old version before extracting a new version.
* Extract the release zip found here.
* Open a terminal.
  * Install the `curl` and `xdelta3` packages using your default package manager. Please consult your distro's information on installing packages if you are having trouble doing this.
  * Navigate to the folder the files have been extracted to (using `ls` to show the files in the current folder and `cd` to enter a directory).
* Type `chmod +x Sharpii rc24.sh` into the terminal and press return.
* Type `./rc24.sh` into the terminal and press return. The patcher will now start.

## Roadmap
* Uninstallation script (and restore unused menus).
* Custom output folder support (instead of Copy-to-SD)
* Extra RiiConnect24 services, akin to the original RiiConnect24 patcher
* Support for other langauges than English.
