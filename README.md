<!--
# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>
-->

[![Build Status](https://cicd.apps.glenux.net/api/badges/glenux/mfm/status.svg)](https://cicd.apps.glenux.net/glenux/mfm)

# Minimalist Fuse Manager (MFM)

MFM is a Crystal-lang CLI designed to streamline the management of various FUSE filesystems, such as sshfs, gocryptfs, httpdirfs, and more. Through its user-friendly interface, users can effortlessly mount and unmount filesystems, get real-time filesystem status, and handle errors proficiently.

## Prerequisites & Dependencies

Before using MFM, make sure the following tools are installed on your system:

- **gocryptfs**: <https://github.com/rfjakob/gocryptfs>
- **sshfs**: <https://github.com/libfuse/sshfs>
- **httpdirfs**: <https://github.com/fangfufu/httpdirfs>
- **fzf**: <https://github.com/junegunn/fzf>

To build from source, you'll also need:

- **crystal-lang**: <https://crystal-lang.org/>

## Installation

### 1. From Source

1. Clone or download the source code.
2. Navigate to the source directory.
3. Run `shards install` to fetch dependencies.
4. Compile using `shards build`.
5. The compiled binary will be in the `bin` directory.

### 2. Binary Download

Alternatively, download a pre-compiled binary version of MFM.

## Usage

### Command Line Options

```
Usage: mfm [options]

Global options:
    -c, --config FILE                Specify configuration file
    -h, --help                       Display this help

Commands:
    create                           Add a new filesystem
    delete                           Remove an existing filesystem
    edit                             Modify the configuration
```

### Demo

<video src="https://code.apps.glenux.net/glenux/mfm/media/branch/develop/doc/output.webm" width="810" height="595" style="max-width: 100%;" controls="controls"></video>

## Configuration

MFM uses a YAML configuration file, typically found at `~/.config/mfm.yml`, to detail the filesystem names, types, and respective configurations.

### YAML File Format

```yaml
version: "1"

global:
  mountpoint: "/home/user/mnt/{{name}}"

filesystems:
  - type: "gocryptfs"
    name: "Work - SSH Keys"
    encrypted_path: "/home/user/.ssh/keyring.work"

  - type: "sshfs"
    name: "Personal - Media Server"
    remote_user: "user"
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

By contributing, you agree to our code of conduct and GPL-2 license terms.

## Authors and Contributors

- Glenn Y. Rolland - *Initial Work*

## Inspired By

- **Qasim**: A user-friendly FUSE manager. <https://code.apps.glenux.net/glenux/qasim>
- **Sirikali**: A Qt/C++ GUI front-end for various FUSE filesystems like cryfs, gocryptfs, securefs, ecryptfs, and encfs. <https://mhogomchungu.github.io/sirikali/>

## License

GNU GPL-3

