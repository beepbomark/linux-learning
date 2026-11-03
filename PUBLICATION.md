# Publishing this learning portfolio

This is a publication checklist, not evidence of a complete security audit.
The repository can stay a work in progress; distinguish learning notes from
measured results and do not publish live infrastructure details.

## Before changing visibility

- Review the README's learning scope and the limitations in individual guides.
- Inspect all branches and history for credentials. A clean latest file is not
  proof that previous commits are clean. Run an approved history-aware secret
  scanner where available, then review findings without publishing values.
- Review commit author/committer email addresses privately. Historical commits
  may contain personal email addresses. Future Git privacy settings do not
  rewrite earlier commits; do not force-push rewritten history without planning.
- Inspect screenshots and attachments for credentials, personal details,
  server addresses and third-party material.
- Review GitHub-only issues, PR discussions, Actions logs/artifacts, releases,
  wiki and attachments where present; a local Git checkout does not cover them.
- Confirm you may publish included coursework and third-party excerpts. Keep
  attribution. Choose a reuse licence separately if desired; no blanket licence
  has been added to other people's material.
- Check Settings for visibility and any public-facing automation. Publishing is
  a separate owner action; a merged documentation PR does not change visibility.

## Secret-file exclusions

`.gitignore` excludes common credential, dump, log and local-tool files. It does
not protect secrets inside ordinary Markdown or scripts, and does not untrack
files already committed. Never use a real secret as an example.

Before each commit, use `git status --short` and `git diff --staged` to review
exactly what will be published. If an actual credential was committed, revoke or
rotate it first; deleting the latest copy alone does not remove history.

## Publication review recorded 3 Nov 2026

A read-only review of main a0416a0 inspected 109 tracked files, five lab screenshots
and 295 historical blobs across 116 locally available commits. Pattern checks
found no private-key blocks, recognized provider tokens, suspicious credential
assignments or production-project references. This was not a dedicated secret
scanner, a full technical review of every command, or inspection of GitHub-only
content. Commit metadata contained personal/provider email addresses; values
are not reproduced here. No credentials were found that require history rewriting.

The follow-up cleanup clarifies the learning scope, replaces an unsafe blanket
Polkit example with inspection guidance, strengthens ignore rules and fixes
unfinished inventory notes. This record does not certify future commits safe.

Source: [GitHub visibility changes](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility).
