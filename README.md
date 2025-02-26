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


`deploy flake.nix#[host] --skip-checks --hostname [123.123.123.123] --magic-rollback false --auto-rollback false`