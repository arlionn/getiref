# getiref
Stata module to get metadata and PDF file of an article given {DOI}

## 1. Install

```stata
ssc install cnssc, replace

cnssc install getiref, replace   // install

help getiref 
```

## 2. Description

`getiref` make it easy to get meta data of most academic articles using their DOIs.
It gets information like **Author name**, **Publication year**, **article Title**, **page range**, and even provides **links to PDFs**, as well as
**.bibtex/.ris** files associated with an anticle.

The citation information can be displayed and exported in various styles,
including Markdown, LaTeX, or Plain text.
This feature enables easy insertion or pasting into .md, .docx, or .tex documents.
It proves highly  practical for efficient literature note-taking, significantly saving time on downloading, organizing PDF
 documents, and managing references.


## 3. Examples 

### 3.1 Quick examples
```stata
    . getiref 10.1257/aer.109.4.1197
    . getiref 10.1257/aer.109.4.1197, cite
    . getiref 10.1257/aer.109.4.1197, pdf bib
    . getiref 10.3368/jhr.50.2.317, pdf bib md
```

### 3.2 Details 

```stata
. getiref 10.1257/aer.109.4.1197
```
![20240113004454](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20240113004454.png)

```stata
. getiref 10.1257/aer.109.4.1197, md pdf bib
```
The PDF documents of this paper will be download and .bibtex and .ris files are listed, 
![20240113005154](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20240113005154.png)

Moreover, the citation text in Markdown format will be displayed in Results Window:
```md
Blanchard, O. (2019). Public Debt and Low Interest Rates. American Economic Review, 109(4), 1197–1229.
[Link](https://doi.org/10.1257/aer.109.4.1197) (rep),
[PDF](http://sci-hub.ren/10.1257/aer.109.4.1197),
[Appendix](https://www.aeaweb.org/doi/10.1257/aer.109.4.1197.appx),
[Google](<https://scholar.google.com/scholar?q=Public Debt and Low Interest Rates>)
```
In Markdown editor, it displays as:  
> Blanchard, O. (2019). Public Debt and Low Interest Rates. American Economic Review, 109(4), 1197–1229. [Link](https://doi.org/10.1257/aer.109.4.1197) (rep), [PDF](http://sci-hub.ren/10.1257/aer.109.4.1197), [Appendix](https://www.aeaweb.org/doi/10.1257/aer.109.4.1197.appx), [Google](<https://scholar.google.com/scholar?q=Public Debt and Low Interest Rates>).

## 4. Advanced usage 

以 `getiref` 为内核 (发动机)，我们可以获取一篇论文的所有参考文献和后续引文的 metadata，下载 PDF 文档和用于导入参考文献管理软件的 .bibtex 或 .ris 文件。下面例子展示了如何使用该命令获得一篇论文的参考文献信息。

With `getiref` as the core engine, we can obtain the metadata for all references and subsequent citations of a paper, download **PDF documents**, and acquire **.bibtex** or **.ris** files for importing into reference management software. 

The following example demonstrates how to use this command to obtain the reference information for a paper.

- Stata dofile: [getiref-get-all-refs.do](https://gitee.com/arlionn/getiref/blob/master/getiref-get-all-refs.do)
- Results: [results-Markdown.md](https://gitee.com/arlionn/getiref/blob/master/results-Markdown.md)

### Stata 

First, you can download the sample dofile '**getiref-get-all-refs.do**' by typing:
```stata
cnssc get getiref, replace // download
```
You may see:

![20240116003802](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20240116003802.png)

Then, you can click `getiref-get-all-refs.do` to open the dofile, or type the following commands:
```stata
doedit "getiref-get-all-refs.do" 
```
If neccessary, modify the inputs in this dofile, and press shortcut **Ctrl+D** to excute the whole dofile.

## 5. Author
- **Yujun Lian** (连玉君) Lingnan College, Sun Yat-Sen University, China.
- E-mail: arlionn@163.com 
- Blog: [lianxh.cn](https://www.lianxh.cn)

## 6. Questions and Suggestions
If you encounter any issues or have suggestions while using the tool, we will address them promptly. Please email us at: <arlionn@163.com>

You can also submit your suggestions by filling out Issues in the project's [GitHub](https://github.com/arlionn/getiref) or [Gitee-Chinese](https://gitee.com/arlionn/getiref)  repository.

