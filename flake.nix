{
  description = "stakeholder-circus swift-stakeholder";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [ swift docker ];
          };
        });
      apps = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
            mk = name: text: {
              type = "app";
              program = "${pkgs.writeShellScript name text}";
            };
        in {
          build = mk "build" ''swift build'';
          test = mk "test" ''swift test'';
          check = mk "check" ''swift build && swift test'';
          format = mk "format" ''if command -v swift-format >/dev/null 2>&1; then swift-format lint --recursive Sources Tests; else echo "swift-format not installed"; fi'';
        });
    };
}
