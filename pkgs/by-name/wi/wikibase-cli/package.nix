{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "wikibase-cli";
  version = "18.3.3";

  src = fetchFromGitHub {
    owner = "maxlath";
    repo = "wikibase-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z0KVY4sXE+7Ftq3O6aozY/HaKCMeTaXUZlpqRNsfmfc=";
  };

  npmDepsHash = "sha256-5s5iG+ChsAF79MI6IFTRydOpTAE5f5f1B5JYtRHMqtY=";

  dontNpmBuild = true;

  meta = {
    description = "Read and edit a Wikibase instance from the command line";
    homepage = "https://github.com/maxlath/wikibase-cli";
    changelog = "https://github.com/maxlath/wikibase-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ montchr ];
    mainProgram = "wikibase-cli";
    platforms = lib.platforms.all;
  };
})
