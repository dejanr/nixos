NixOS configuration for various machines.

### Structure

```
.
├── machines
├── packages
├── roles
├── scripts
└── wallpapers
```

* A **machine** has one or more role
* A **package** is derived or custom package
* A **role** is a collection of **packages** and **services**

### Secrets

Secrets are stored in `secrets.nix`, which looks something like this:

```
{
  name = {
    username = "foo";
    password = "bar";
  };
}
```

### Setup

Symlink machine to configuration.nix.

```
ln -s /etc/nixos/machines/homelab.nix /etc/nixos/configuration.nix
```

### Build

To build a machine and activate result.

```
sudo nixos-rebuild switch
```
