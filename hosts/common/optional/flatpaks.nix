{inputs, ...}: {
  imports = [
    inputs.flatpaks.nixosModules.default
  ];
}
