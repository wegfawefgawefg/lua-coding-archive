# Nested Repo Histories (Archive)

These tarballs preserve original nested `.git` directories that were removed to avoid submodule/gitlink behavior in the parent archive repo.

## Contents
- `1_UseAttempt__2DRayCaster__.git.tar.gz`
- `1_UseAttempt__ExciteKike__.git.tar.gz`
- `1_UseAttempt__TileBasedScrollingExample__.git.tar.gz`
- `1_UseAttempt__WorldRayCastExample__.git.tar.gz`
- `ExciteKike2__.git.tar.gz`

## Integrity
- See `SHA256SUMS.txt` for checksums.

## Restore Example
From repo root, to restore one nested history:

```bash
tar -xzf archive/nested-git-histories/1_UseAttempt__2DRayCaster__.git.tar.gz -C Lua/1_UseAttempt/2DRayCaster
```

This will recreate `Lua/1_UseAttempt/2DRayCaster/.git`.
