# Git

Shortcuts for Git commands.

## `git loglist`
Returns a simple, compact list of all commits. It is a simple _git alias_.

## `git save`
Allows to execute `git add -A`, `git commit`, `git push`, and `git log -1`, all at once.
- ### Usage:
  - `git save`
    - `--skip-add` or `-s`:
      - Skips `git add -A`.
      - The default is to not skip.
    - `--amend` or `-a`:
      - Apply `--amend` on the `commit`.
      - If `--push` is also used, then it receives `-f`.
    - `--reamend` or `r`:
      - Apply `--amend --no-edit` on the `commit`.
      - If `--push` is also used, then it receives `-f`.
    - `--push` or `-p`:
      - Executes `git push`.
      - The default is to not execute.
    - `"title"`:
      - The "commit title", applied with `-m`.
    - `"message"`:
      - The "commit message", applied with `-m`.
  - ### Notice:
    - The first `"text"` is the `"title"`, the second is `"message"`. All the following `"text"` is ignored.
    - The order of the params doesn't matter.
    - If `--amend` is used with `--reamend`, then `--reamend` is applied.
    - If `--reamend` is used with `"title"`, then `--amend` is applied.
    - The shorthands can be used together. Ex.: `-ap` applies `--amend` and `git push -f`.
    - It is necessary to have a `"title"`, or an error is thrown. Except when used `--reamend`.
- ### Examples:
  - `git save --amend --push "Titulo" "Mensagem"`.
  - `git save -sa "Titulo" "Mensagem" -p"`.
  - `git save "Titulo" -p "Mensagem" --amend`.
  - `git save -r"`.
  - `git save -rps"`.

## `git quicksave`
Simply executes `git save` with the current date(_DD/MM/AAAA_) as `"title"`.

## Instalation
It's the file `C:\Users\USER\.gitconfig`, present if _Git_ is installed.
