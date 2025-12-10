# Cyrillic Phonetic Layout for Linux

This directory contains the XKB version of the Cyrillic Phonetic layout.

## Installation

1. Unzip the archive:
   ```sh
   unzip layout.zip
   ```

2. Copy the layout file into the XKB symbols directory:
   ```sh
   sudo cp <layout-file> /usr/share/X11/xkb/symbols/
   ```

3. Rebuild the keyboard layout cache:
   ```sh
   sudo dpkg-reconfigure xkb-data
   ```

4. Add the new layout in system keyboard settings.
