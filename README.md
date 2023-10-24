# Minimalist Fuse Manager (MFM)

MFM is a Crystal-lang CLI tailored to simplify the management of encrypted vaults using multiple FUSE filesystems such as sshfs, gocryptfs, httpdirfs, and more. It provides a user-friendly interface, enabling users to smoothly mount and unmount filesystems, obtain filesystem status, and handle errors adeptly.

## Prerequisites & Dependencies

Before using MFM, ensure the following tools are installed on your system:

- **gocryptfs**: <https://github.com/rfjakob/gocryptfs>
- **sshfs**: <https://github.com/libfuse/sshfs>
- **httpdirfs**: <https://github.com/fangfufu/httpdirfs>
- **fzf**: <https://github.com/junegunn/fzf>

To build from source, you'll also require:

- **crystal-lang** : <https://crystal-lang.org/>

## Installation

### 1. From Source

1. Clone or download the source code.
2. Navigate to the source directory.
3. Execute `shards install` to obtain dependencies.
4. Compile using `shards build`.
5. Find the compiled binary in the `bin` directory.

### 2. Binary Download

You can also fetch a pre-compiled binary version of MFM.


## Usage

### Command Line Options

```
Usage: mfm [options]

Global options:
    -c, --config FILE                Define configuration file
    -h, --help                       Showcase this help

Commands:
    create                           Instantiate a new vault
    delete                           Erase an existing vault
    edit                             Adjust the configuration
```


## Configuration

The script harnesses a YAML configuration file, typically located at `~/.config/mfm.yml`, which outlines vault names and paths.

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
  
  # Incorporate more vaults as necessary
```

## Contribution Guidelines

To contribute to MFM:

1. **Fork the Repository**: Begin by forking the MFM repository.
2. **Create a Feature Branch**: Every feature or fix should reside in distinct branches.
3. **Commit Changes**: Commit with expressive messages.
4. **Run Tests**: Confirm no functional disruptions.
5. **Push to Your Fork**: Transfer changes to your GitHub fork.
6. **Submit a Pull Request**: Commence a pull request to the main repo, elaborating on your changes.
7. **Review**: Anticipate feedback from maintainers and react suitably.

Contributors are bound by our code of conduct and the terms of the GPL-2 license.

## Authors and Contributors

- Glenn Y. Rolland - *Initial Work*

## Inspired By

- **Qasim**: A user-convenient FUSE manager. <https://code.apps.glenux.net/glenux/qasim>
- **Sirikali**: A Qt/C++ GUI front end for various FUSE filesystems like cryfs, gocryptfs, securefs, ecryptfs, and encfs. <https://mhogomchungu.github.io/sirikali/>

## License

GNU GPL-2
