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

To use secret you would then just import secrets and access specific field:

```
password = (import ../secrets.nix).name.password;
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

### Nix Darwin

OSX requires some additional bootstrapping, minimal manual setup i found to work so far is bellow.

#### Create run symlink

```
sudo ln -s private/var/run /run
```

#### export NIX_PATH

```
export NIX_PATH=darwin=/etc/nixos/darwin:darwin-config=/etc/nixos/configuration.nix:$NIX_PATH
```

#### Install nix-darwin

```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

#### Normal nix-darwin rebuild

```
darwin-rebuild switch
```

