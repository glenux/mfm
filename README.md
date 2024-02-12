<!--
# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>
-->

[![Build Status](https://cicd.apps.glenux.net/api/badges/glenux/mfm/status.svg)](https://cicd.apps.glenux.net/glenux/mfm)
![License LGPL3.0-or-later](https://img.shields.io/badge/license-LGPL3.0--or--later-blue.svg)
[![Donate on patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://patreon.com/glenux)

> :information_source: This project is available on our self-hosted server and
> on CodeBerg and GitHub as mirrors. For the latest updates and comprehensive
> version of our project, please visit our primary repository at:
> <https://code.apps.glenux.net/glenux/mfm>.

<!-- hello -->

# Minimalist Fuse Manager (MFM)

MFM is a Crystal-lang CLI designed to streamline the management of various FUSE filesystems, such as sshfs, gocryptfs, httpdirfs, and more. Through its user-friendly interface, users can effortlessly mount and unmount filesystems, get real-time filesystem status, and handle errors proficiently.

## Prerequisites & Dependencies

Before using MFM, make sure the following tools are installed on your system:

- **gocryptfs**: <https://github.com/rfjakob/gocryptfs>
- **sshfs**: <https://github.com/libfuse/sshfs>
- **httpdirfs**: <https://github.com/fangfufu/httpdirfs>
- **fzf**: <https://github.com/junegunn/fzf>
- libpcre3
- libevent-2.1

For Debian/Ubuntu you can use the following command:

```shell-session
$ sudo apt-get update && sudo apt-get install libpcre3 libevent-2.1-7 fzf gocryptfs httpdirfs sshfs
```

## Building from source

To build from source, you'll also need:

- **crystal-lang**: <https://crystal-lang.org/>

For Debian/Ubuntu you can use the following command:

```shell-session
$ sudo apt-get update && sudo apt-get install libpcre3-dev libevent-2.1-dev make
```

## Installation

### 1. From Source

To get started with MFM, ensure that you have the prerequisites installed on your system (see above).

Then follow these steps to install:

    git clone https://code.apps.glenux.net/glenux/mfm
    cd mfm
    make prepare
    make build
    sudo make install                 # either to install system-wide
    make install PREFIX=$HOME/.local  # or to install as a user

### 2. Binary Download

Alternatively, download [a pre-compiled binary
version](https://code.apps.glenux.net/glenux/mfm/releases) of MFM.

## Usage

### Command Line Options

Global

```
Usage: mfm [options]

Global options
    -c, --config FILE                Set configuration file
    -v, --verbose                    Set more verbosity
    -o, --open                       Automatically open directory after mount
    --version                        Show version
    -h, --help                       Show this help

Commands (not implemented yet):
    config                           Manage configuration file
    mapping                          Manage filesystems
```

Config management

```
Usage: mfm filesystem [options]

Global options
    -c, --config FILE                Set configuration file
    -v, --verbose                    Set more verbosity
    -o, --open                       Automatically open directory after mount
    --version                        Show version
    -h, --help                       Show this help

Commands (not implemented yet):
    init                             Create init file
```

Filesystem management

```
Usage: mfm mapping [options]

Global options
    -c, --config FILE                Set configuration file
    -v, --verbose                    Set more verbosity
    -o, --open                       Automatically open directory after mount
    --version                        Show version
    -h, --help                       Show this help

Commands (not implemented yet):
    list                             List fuse mappings
    create                           Create new fuse mapping
    edit                             Edit fuse mapping
    delete                           Create new fuse mapping
```

### Demo

<video src="https://code.apps.glenux.net/glenux/mfm/media/branch/develop/doc/output.webm" width="810" height="595" style="max-width: 100%;" controls="controls"></video>

## Configuration

MFM uses a YAML configuration file, typically found at `~/.config/mfm.yml`, to
detail the filesystem names, types, and respective configurations.

### YAML File Format

```yaml
---
version: "1"

global:
  mountpoint: "{{env.HOME}}/mnt"

filesystems:
  - type: "gocryptfs"
    name: "Work - SSH Keys"
    encrypted_path: "/home/user/.ssh/keyring.work.vault"

  - type: "sshfs"
    name: "Personal - Media Server"
    remote_user: "{{env.USER}}"
    remote_host: "mediaserver.local"
    remote_path: "/mnt/largedisk/music"
    remote_port: 22

  - type: httpdirfs
    name: "Debian Repository"
    url: "http://ftp.debian.org/debian/"

  # Add more filesystems as needed
```

## Contribution Guidelines

Contributing to MFM:

1. **Fork the Repository**: Start by forking MFM's repository.
2. **Create a Feature Branch**: Develop each feature or fix in its own branch.
3. **Commit Changes**: Provide clear and informative commit messages.
4. **Run Tests**: Ensure that all features are operational.
5. **Push to Your Fork**: Push your changes to your fork on GitHub.
6. **Submit a Pull Request**: Begin a pull request to the main repository and explain your changes.
7. **Review**: Await feedback from the maintainers and respond as necessary.

By contributing, you agree to our code of conduct and license terms.

## Authors and Contributors

- Glenn Y. Rolland - *Initial Work*

## Inspired By

- **Qasim**: A user-friendly FUSE manager. <https://code.apps.glenux.net/glenux/qasim>
- **Sirikali**: A Qt/C++ GUI front-end for various FUSE filesystems like cryfs, gocryptfs, securefs, ecryptfs, and encfs. <https://mhogomchungu.github.io/sirikali/>

## License

GNU GPL-3

