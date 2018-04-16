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

Create run symlink

```
sudo ln -s private/var/run /run
```

And rebuild switch darwin

```
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
```

