"""Sphinx documentation markdown symlink utilities."""

import os
import shutil


def clean(symlink_base):
    """Remove all existing symlinks from the target folder."""
    if os.path.exists(symlink_base):
        if os.path.islink(symlink_base):
            os.unlink(symlink_base)
        else:
            shutil.rmtree(symlink_base)


def create(md_files, src_dir, symlink_base):
    """Create relative symlinks for the given list of markdown files."""
    os.makedirs(symlink_base, exist_ok=True)

    for rel_path in md_files:
        source_file_abs = os.path.abspath(str(os.path.join(src_dir, rel_path)))

        link_path_abs = os.path.join(symlink_base, rel_path)
        link_dir_abs = os.path.dirname(link_path_abs)

        if not os.path.exists(link_dir_abs):
            os.makedirs(link_dir_abs, exist_ok=True)

        relative_source = os.path.relpath(source_file_abs, link_dir_abs)

        try:
            os.symlink(relative_source, link_path_abs)
        except OSError as e:
            print(f"--- Failed to link {rel_path}: {e} ---")
