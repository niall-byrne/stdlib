"""Sphinx general configuration."""

# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

project = "stdlib"
author = "Niall Byrne"
copyright = "2026, Niall Byrne"
release = "2026"

exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

extensions = [
    "myst_parser",
]

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

templates_path = ["_templates"]
