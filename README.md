# getiref
Stata module to get meta data and PDF file of an article given {DOI}

## Install and help 

```stata
ssc install cnssc, replace

cnssc install getiref, replace
help getiref 
```

## Description

`getiref` make it easy to get meta data of most academic articles using their DOIs.
It gets information like **Author name**, **Publication year**, **article Title**, **page range**, and even provides **links to PDFs**, as well as
**.bibtex/.ris** files associated with an anticle.

The citation information can be displayed and exported in various styles,
including Markdown, LaTeX, or Plain text.
This feature enables easy insertion or pasting into .md, .docx, or .tex documents.
It proves highly  practical for efficient literature note-taking, significantly saving time on downloading, organizing PDF
 documents, and managing references.


## Examples 

### Quick examples
```stata
    . getiref 10.1257/aer.109.4.1197
    . getiref 10.1257/aer.109.4.1197, cite
    . getiref 10.1257/aer.109.4.1197, pdf bib
    . getiref 10.3368/jhr.50.2.317, pdf bib md
```

### Details 

```stata

```
