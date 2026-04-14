This is Joseph's *home directory*

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

Relevant for dotfiles: Joseph uses `chezmoi` to manage dotfiles. The source directory is `~/.local/share/chezmoi`. Edit files there (e.g. `.tmpl` templates) rather than the destinations, then `chezmoi apply` to push changes.

Exception: `~/.claude/settings.json` is intentionally unmanaged because Claude edits it frequently.
