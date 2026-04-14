"""Sphinx documentation markdown utilities."""

import os


def discover(project_root, target_folder, filter_path=None):
    """Discover all markdown files in the target folder."""
    root_folder = str(os.path.join(project_root, target_folder))

    md_files = []
    for root, _, files in os.walk(root_folder):
        if filter_path is not None and filter_path in root:
            continue
        for file in files:
            if file.endswith(".md"):
                rel_path = os.path.relpath(os.path.join(root, file),
                                           root_folder)
                md_files.append(os.path.join(target_folder, rel_path))
    return md_files
