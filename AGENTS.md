This is Joseph's *home directory*.

Important:
- Treat `/home/shetaye` as a live home directory, not an isolated project checkout.
- For dotfiles, use `chezmoi`. The source directory is `~/.local/share/chezmoi`.
- Edit files in the `chezmoi` source tree (for example `dot_*`, `private_*`, and `.tmpl` files) rather than their destinations in `$HOME`.
- After changing managed dotfiles, run `chezmoi apply` to update the destination files.
- `~/.claude/settings.json` is intentionally unmanaged because Claude edits it frequently.

Relevant subdirectories:
- `.config/`: Dotfiles
- `.emacs.d/`: Emacs configuration
- `projects/`: Programming work, further divided into
    - `foss/`: General open source software (e.g. from Github)
    - `personal/`: Non-open software developed personally
    - `stanford/`: Work done for Stanford University courses
    - `singularity/` and `tibex/`: Professional work
- `org/`: Root of org files
- `docs/`: Documents (e.g. readings, pdfs, epubs, etc.)
- `typst/`: Typst compilation root
- `tex/`: (La)Tex compilation root
- `media/`: Media (e.g. screenshots, etc.)
