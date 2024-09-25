{ lib, buildGoModule, fetchFromGitHub, testers, ddev }:

buildGoModule rec {
  pname = "ddev";
  version = "1.23.4";

  src = fetchFromGitHub {
    owner = "ddev";
    repo = "ddev";
    rev = "v${version}";
    hash = "sha256-+Ou9YbFwUVu6AqR041ngnVb9TpiO1UMph2w1zsbEMEM=";
  };

  vendorHash = null;

  ldflags = [
    "-extldflags -static"
    "-X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=${src.rev}"
    "-X github.com/ddev/ddev/pkg/versionconstants.SegmentKey=${src.rev}"
  ];

  # Tests need docker.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ddev;
    command = ''
      # DDEV will try to create $HOME/.ddev, so we set $HOME to a temporary
      # directory.
      export HOME=$(mktemp -d)
      ddev --version
    '';
  };

  meta = with lib; {
    description = "Docker-based local PHP+Node.js web development environments";
    homepage = "https://ddev.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "ddev";
    maintainers = [ maintainers.montchr ];
  };
}
