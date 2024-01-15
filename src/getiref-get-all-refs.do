*----------------------------------------
*----------------------------------------
*
* 获取一篇论文的所有参考文献的引文信息
*
*----------------------------------------
*----------------------------------------
*  包括：
*    引文链接，
*    PDF，
*    可用于导入 Endnote 等文献管理软件的 .ris / .bibtex 文件等

* Author: Yujun Lian, arlionn@163.com, 2024/1/15 20:16
*
* 仓库地址：
  view browse "https://gitee.com/arlionn/getiref"
  
  
  
*============ A. 参数设定 ================ begin ======

*-~~~~~~~~~ 此处填入待检索的文献的 DOI ~~~~~~~~~~~~~(!!!! important !!!! )
   
//   global DOI "10.1257/aer.109.4.1197" 
//   global DOI "10.1177/1536867X20953574"      // SJ 
  global DOI "10.1016/j.jfineco.2017.04.001" // JFE, 70 refs
//   global DOI "10.1016/j.econlet.2021.110063" // Eco Letters, 2022, 6 refs 

*-是否下载 PDF 文件和 .ris, .bibtex 文档
  global pdf "pdf"
//   global bib "bib"
  global bib ""
  global md  "md"   // 备选：text, latex 
  
* 清屏 (可选，如果不需要可以注释掉)
  cls 

*-存储路径：存储 PDF 文件的路径名称 (若不存在, 则自动新建一个)
  global Root "D:/_temp_getiref" 
  qui getiref $DOI, path($Root)
  global filename "`r(author1)'_`r(year)'"
  global path "$Root/$filename"  // Folder for jth paper
  !md "$path"
  cd  "$path"   
  
*============ A. 参数设定 ================ over =======

*-安装 getiref 命令 (若已经安装请忽略这两行)
  cap which cnssc
  if _rc   ssc install cnssc, replace 
  cap which getiref
  if _rc   cnssc install getiref, replace 

*-获取数据，并保存为 .txt 和 .dta 数据
  //   local type "citations"  // 引文，暂时不可用
  local type "references"   // 参考文献
  local api_url "https://opencitations.net/index/coci/api/v1/`type'"   
  local url "`api_url'/$DOI"
  
  qui copy `"`url'"'  "doi_ref.txt", replace 

  qui infix strL v 1-1000 using "doi_ref.txt", clear

  if _N == 1{
      dis as error "No observation"
  }
  
  qui save "doi_ref_OpenCitation.dta", replace  
  

*-----------------
*-Type: references
*-----------------

qui{      // qui ----------------------- begin -----------------
    
  use "doi_ref_OpenCitation.dta", clear 
  
  gen Is_cited = strpos(v, "cited") 
  keep if Is_cited==1 
  
*-get DOI
  clonevar DOI = v
  replace  DOI = subinstr(DOI, `"cited": ""', "", .)  
  replace  DOI = subinstr(DOI, `"","', "", .)  
  
*-get references text using -getref.ado-  
  
  local N  = _N
  gen strL ref_out = ""
  gen strL ref_dis = ""
  gen fail = 0
  
  local n_ok = 0
  forvalues i = 1/`N'{
      local doi = DOI[`i']

   // ~~~~~~~~~ Energine ----------------------  
      cap noi getiref `doi', path("$path")  ///
	          $md $bib $pdf clipoff notip   
   // ~~~~~~~~~ Energine ----------------------  
   
      if _rc==0{
          qui replace ref_out = "- `r(ref)'" in `i'
          qui replace ref_dis = `"`r(ref_link_pdf_full)'"' in `i'
          local n_ok = `n_ok' + 1 // number of references found sucessfully
      }
      else{ // 这里要分类别显示错误信息，有些是无法获得 bib，有些是无法获得 PDF
          qui replace fail = 1 in `i'
          dis as error "failed to get metadata for {DOI}: `doi'"
      }
  }  
     
     
*---------------------
*- Display and Export 
*---------------------

* Note: 这部分内容可以反复执行，快速重现结果
  sort ref_out 
  
  // local item "-"
  local n_ok = _N   
  
  forvalues i = 1/`n_ok'{
  
      noi dis "`i'.`item' " ref_dis[`i']
   
  }  

  
*-输出为 Markdown  文档
    local path : pwd
    local saving "${filename}.md"
    
    qui export delimited ref_out using `"`path'/`saving'"' , ///
    	       novar nolabel delimiter(tab) replace
    local save "`saving'"   
    	    noi dis " "
    		noi dis _dup(58) "-" _n ///
    				_col(3)  `"{stata `" view  "`path'/`save'" "': View}"' ///
    				_skip(4) `"{stata `" !open "`path'/`save'" "' : Open_Mac}"' ///
    				_skip(4) `"{stata `" winexec cmd /c start "" "`path'/`save'" "' : Open_Win}"' ///
                    _skip(4) `"{browse `"`path'"': dir}"'
            noi dis _dup(58) "-"

}      // qui ----------------------- over -----------------  
  
*-Statis
  dis in red ">>>>>>>>>>>>"
  dis `"{cmd:`n_ok'} out of {cmd:`N'} references found sucessfully for the following article:"'
  *-目标文献信息
  getiref $DOI, path($path)
  global filename "`r(author1)'_`r(year)'"
  dis "$filename"
  dis `"References' documents are saved in: `path'"' _skip(4)  `"{browse `"`path'"': Browse}"'

  
* ---------------------- over ----------------------- 