# my-little-flake

# Clevis


### (Method 1) encrypt secret with tpm
`echo -n "thisismyverylongpassword" | clevis encrypt tpm2 '{}' > hi.jwe`

### (Method 2) or generate a random secret with tpm and then encrypt it
`sudo tpm2_getrandom --hex 32 >> mysecret.txt`

and

`printf %s $(<mysecret.txt) | sudo clevis encrypt tpm2 '{}' > hi.jwe`


### add "thisismyverylongpassword" to luks
`cryptsetup luksAddKey /dev/(nvme0n1p2)`

### add hi.jwe to sops
`sops path/to/sops.yaml`

# Deploy


### fast deploy-rs
`deploy flake.nix#[host] --skip-checks --hostname [123.123.123.123] --magic-rollback false --auto-rollback false`

### big upgrade
#### git on the main device
`git add . && git commit && git push rad main`
also
`rad node start`
#### git on the remote device
`git pull rad main`
#### upgrade
enter tmux
`sudo nixos-rebuild switch --flake .`
