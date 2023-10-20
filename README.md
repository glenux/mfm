# GX-Vault Manager

GX-Vault Manager is a Crystal-lang script that helps in managing encrypted vaults using `gocryptfs`. The script offers a user-friendly interface for mounting and unmounting vaults, providing real-time status and handling errors gracefully.

## Configuration

The script uses a YAML configuration file, typically stored at `~/.config/gx-vault.yml`. This file contains details about the vaults, including their names and paths.

## YAML File Format

The configuration file consists of an array of vaults, with each vault having a name and an encrypted path. Below is the structure of the YAML file:

```yaml
vaults:
  - name: "vault1"
    encrypted_path: "/absolute/path/to/vault1"
  
  - name: "vault2"
    encrypted_path: "/absolute/path/to/vault2"
  
  # Add more vaults as needed
```

## Fields Description

- **vaults:** The root element containing an array of all defined vaults.

- **name:** The unique name of the vault. This is used for display and selection purposes.

- **encrypted_path:** The absolute path to the directory where the encrypted data is stored. This path is used by `gocryptfs` for mounting the vault.

## Example

Here is a sample configuration with two vaults named "Personal" and "Work":

```yaml
vaults:
  - name: "Personal"
    encrypted_path: "/home/user/encrypted/personal"
    
  - name: "Work"
    encrypted_path: "/home/user/encrypted/work"
```

## Usage

Once the YAML configuration file is set up, run the script. It will read the configuration, and you can select a vault to mount or unmount using the `fzf` interactive selector. The status of each vault (whether it's open or closed) is displayed next to the vault's name.

## Dependencies

- gocryptfs
- fzf
- Crystal-lang
- Other dependencies as per the Crystal-lang script

## License

GPL-2
