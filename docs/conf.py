"""Configuration file for the Sphinx documentation builder."""

#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

import os
import sys

sys.path.insert(0, os.path.abspath("."))

from conf import markdown, symlinks
from conf.general import (
    author,  # noqa: F401
    copyright,  # noqa: F401
    exclude_patterns,  # noqa: F401
    extensions,  # noqa: F401
    project,  # noqa: F401
    release,  # noqa: F401
    source_suffix,  # noqa: F401
    templates_path,  # noqa: F401
)
from conf.html import html_static_path, html_theme  # noqa: F401
from conf.myst import myst_heading_anchors  # noqa: F401


def setup(_app):
    """Sphinx setup function to hook into the build process."""
    docs_root = os.path.abspath(os.path.dirname(__file__))
    project_root = os.path.join(docs_root, "..")
    symlink_reference_base = os.path.join(
        docs_root,
        "reference",
    )
    symlink_testing_reference_base = os.path.join(
        docs_root,
        "reference_testing",
    )

    symlinks.clean(symlink_reference_base)
    symlinks.clean(symlink_testing_reference_base)

    md_files = ["REFERENCE.md"]
    md_files += markdown.discover(project_root, "src", "testing")
    symlinks.create(md_files, project_root, symlink_reference_base)

    md_files = ["REFERENCE_TESTING.md"]
    md_files += markdown.discover(project_root, "src/testing")
    symlinks.create(md_files, project_root, symlink_testing_reference_base)

    print(f"--- Added {len(md_files)} Markdown files ---")
