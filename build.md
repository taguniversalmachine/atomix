# Build Instructions

Building the `atomix` Nif requires first building and flashing and AtomVM image containing the Nif code in this repository:

1. Build AtomVM, including the Nif "component"
1. Build an AtomVM image file
1. Erase the ESP32 device and flash the AtomVM image file to the ESP32 device

Once the AtomVM image is created and flashed, you can then develop your application in an iterative fashion:

1. Integrate the Atomix library into your application
1. Flash your application to the ESP32 device
1. Debug/Fix/Flash/Repeat

> Note.  This library requires use of the IDF SDK version 4.2.1 or later.  Currently, this version of the IDF SDK is considered _experimental_ for use with AtomVM.


## Build AtomVM, including the `atomix` Nif

### Prerequisites

Because the IDF SDK does not support dynamic loading of components, any extensions to the AtomVM virtual machine must be linked into the AtomVM image.  Therefore, building the `atomix` Nif requires that you build the AtomVM virtual machine.

Instructions for setting up a build environment for AtomVM are outside of the scope of this document.

> For build instructions of the AtomVM Virtual machine on the ESP32 platform, see [here](https://github.com/bettio/AtomVM/blob/master/README.ESP32.Md#building-atomvm-for-esp32).

The remaining sections assume you have downloaded the AtomVM github repository and have all of the prerequisites neeed to build an AtomVM image targeted for the ESP32 platform.

### Build Steps

Clone this repository in the `src/platforms/esp32/components` directory of the AtomVM source tree.

    shell$ cd .../AtomVM/src/platforms/esp32/components
    shell$ git clone https://github.com/taguniversalmachine/atomix.git

After running a full build, edit the `component_nifs.txt` file in `src/platforms/esp32/main` (this file will be created as the result of running a build).  The contents of this file should contain a line for the `atomvm_neopixel` nif:

    atomix

Build AtomVM (typically run from `src/platforms/esp32`)

    shell$ cd .../AtomVM/src/platforms/esp32
    shell$ make
    ...
    CC .../AtomVM/src/platforms/esp32/build/atomvm_neopixel/priv/c_src/atomvm_neopixel.o
    AR .../AtomVM/src/platforms/esp32/build/atomvm_neopixel/libatomvm_neopixel.a
    ...
    To flash all build output, run 'make flash' or:
    python /opt/esp-idf-v3.3/components/esptool_py/esptool/esptool.py --chip esp32 --port /dev/tty.SLAB_USBtoUART --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 .../AtomVM/src/platforms/esp32/build/bootloader/bootloader.bin 0x10000 .../AtomVM/src/platforms/esp32/build/atomvvm-esp32.bin 0x8000 .../AtomVM/src/platforms/esp32/build/partitions.bin

Once the AtomVM image is flashed to the ESP32 device, it includes the internal interfaces needed for communicating with the hardware on the ESP32 device.

## Build and flash an AtomVM image file

If you have already flashed a full AtomVM image to your ESP32 device, then you can simply issue the `flash` target to your device, in order to upload the AtomVM binary image to your device.

Otherwise, you will need to build a complete AtomVM image, containing the boot partition, AtomVM BEAM libraries, and AtomVM image, and then flash it to your device.

Fortunately, AtomVM contains scripts that make this relatively painless.

From the top level source directory of the AtomVM source tree, issue:

    shell$ ./tools/release/esp32/mkimage.sh
    Writing output to .../AtomVM/src/platforms/esp32/build/atomvm-c734de9.img
    =============================================
    Wrote bootloader at offset 0x1000 (4096)
    Wrote partition-table at offset 0x8000 (32768)
    Wrote AtomvVM Virtual Machine at offset 0x10000 (65536)
    Wrote AtomvVM Core BEAM Library at offset 0x110000 (1114112)

You can now flash this image to your ESP32 device:

    shell$ ./tools/release/esp32/flashimage.sh
    %%
    %% Flashing .../AtomVM/src/platforms/esp32/build/atomvm-c734de9.img (size=2108k)
    %%
    esptool.py v2.8-dev
    Serial port /dev/ttyUSB0
    Connecting....
    Chip is ESP32D0WDQ6 (revision 1)
    Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
    Crystal is 40MHz
    MAC: 3c:71:bf:84:d9:08
    Uploading stub...
    Running stub...
    Stub running...
    Changing baud rate to 921600
    Changed.
    Configuring flash size...
    Auto-detected Flash size: 4MB
    Wrote 1163264 bytes at 0x00001000 in 14.2 seconds (656.8 kbit/s)...
    Hash of data verified.
    Leaving...
    Hard resetting via RTS pin...

> Note.  You can set the `FLASH_SERIAL_PORT` and `FLASH_BAUD_RATE` environment variables to suit your environment, if necessary.  E.g., under bourne shell and its derivatives:

    shell$ export FLASH_SERIAL_PORT=/dev/tty.SLAB_USBtoUART
    shell$ export FLASH_BAUD_RATE=921600

Your ESP32 device is now ready for integration with your application.

## Integrate the `atomix` Library

### Prerequisites

Integrating the `atomvm_neopixel` library requires [rebar3](https://www.rebar3.org) and [git](https://git-scm.com)

### Integration Steps

Add the following dependencies to your `mix.exs` file:

    defp deps do
    [
    {atomix, {git, "https://github.com/taguniversalmachine/atomix.git", {branch, "master"}}},
    {:exatomvm, {git, "https://github.com/atomvm/ExAtomVM.git"}
    ]

Fetch the dependencies:

     shell$ mix deps.get 

Configure the hardware:

Atomix will generate a driver specifically for your hardware configuration, so edit your config.exs to add an atomix configuration. You can start from this [example](confgig/config.example.exs).
Once the hardware is configured, you may now issue 

    shell$ mix atomix.gen.driver 

This mix task will read the configuration, create the necessary NIF files, and compile them for your platform.
The task will also create the Atomix.Hardware module that you will integrate into your application. The Atomix.Hardware module interoperates with the generated NIFs to provide your application direct access to the hardware.

Thus, for example, if you need to specify a non-default port:

    shell$ rebar3 esp32_flash -p /dev/tty.SLAB_USBtoUART
    ===> Verifying dependencies...
    ===> App neopixel is a checkout dependency and cannot be locked.
    ===> Analyzing applications...
    ===> Compiling neopixel
    ===> Analyzing applications...
    ===> Compiling neopixel_example
    ===> AVM file written to : neopixel.avm
    ===> AVM file written to : my_app.avm
    ===> esptool.py --chip esp32 --port /dev/tty.SLAB_USBtoUART --baud 115200 --before default_reset --after hard_reset write_flash -u --flash_mode dio --flash_freq 40m --flash_size detect 0x210000 .../my_app/_build/default/lib/my_app.avm

    esptool.py v2.1
    Connecting........_
    Chip is ESP32D0WDQ6 (revision (unknown 0xa))
    Uploading stub...
    Running stub...
    Stub running...
    Configuring flash size...
    Auto-detected Flash size: 4MB
    Wrote 16384 bytes at 0x00210000 in 1.4 seconds (91.3 kbit/s)...
    Hash of data verified.

    Leaving...
    Hard resetting...

You are now ready to integrate the [`atomix` API](guide.md) into your application.