# EBPRM Rehabilitation for War Casualties

This repository houses a website of the European Board of PRM Doctors dedicated to the
rehabilitation for early war casualties.

The repository is responsible for downloading and converting MS Word documents to markdown
so that they can be served on the web.

It is built using [MkDocs Material](https://squidfunk.github.io/mkdocs-material/), the conversion
from Word to Markdown happens through [Pandoc](https://pandoc.org/).

# Why

The point of this is to make turning the available documents into a web-format as easy as possible
as well as automated. The `main.sh` file will be initially ran as a cron-job to ensure that
any update to the documents will be automatically reflected on the website.
