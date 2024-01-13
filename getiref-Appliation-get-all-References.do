*----------------------------------------
*----------------------------------------
*
* Get citation information for all references of a paper
*
*----------------------------------------
*----------------------------------------
*  Includes:
*    Citation links,
*    PDFs,
*    .ris/.bibtex files for importing into reference management software, etc.

* Author: Yujun Lian, arlionn@163.com, 2024/1/13 9:38
*
* Repository address:
  view browse "https://gitee.com/arlionn/getiref"
  
  

*============ A. Parameter Setting ================ begin ======

*-Install the getiref command (ignore these two lines if already installed)
  ssc install cnssc, replace 
  cnssc install getiref, replace 

*-Storage path
  local path "D:/_temp"   // Enter the local path or the path to store PDF files, can be modified
  cap !md `path'
  cap cd  `path' 

*-Enter the DOI of the literature to be searched (!!!! important !!!! )
*          ------------------    
  *global DOI "10.1257/aer.109.4.1197" 
   global DOI "10.1177/1536867X20953574"  // SJ 


*-Download PDF files and .ris/.bibtex documents
  global pdf "pdf"
  global bib "bib"
  global md  "md"   // Alternatives: text, latex 
  
* Clear screen (optional, comment out if not needed)
  cls
  
*============ A. Parameter Setting ================ over =======

*-Target literature information
  getiref $DOI, all 
  global filename "`r(author1)'_`r(year)'"
  dis "$filename"


*-Get data and save as .txt and .dta files
  //   local type "citations"  // Citations, temporarily unavailable
  local type "references"   // References
  local api_url "https://opencitations.net/index/coci/api/v1/`type'"   
  local url "`api_url'/$DOI"
  
  copy `"`url'"'  "doi_ref.txt", replace 

  infix strL v 1-1000 using "doi_ref.txt", clear

  if _N == 1{
      dis as error "No observation"
  }
  
  save "doi_ref_OpenCitation.dta", replace  
  

*-----------------
*-Type: references
*-----------------

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

      cap noi getiref `doi', $md $bib $pdf clipoff   // Core command
       
      if _rc==0{
          qui replace ref_out = "- `r(ref)'" in `i'
          qui replace ref_dis = `"`r(ref_link_pdf_full)'"' in `i'
          local n_ok = `n_ok' + 1 // number of references found successfully
      }
      else{ // Categorize and display error messages, some are unable to get bib, some are unable to get PDF
          qui replace fail = 1 in `i'
          dis as error "failed to get meta for {DOI}: `doi'"
      }
  }
  dis `"{cmd:`n_ok'} out of {cmd:`N'} references found successfully"'
  
     
     
*---------------------
*- Display and Export 
*---------------------

* Note: This part can be executed repeatedly to quickly reproduce results
  sort ref_out 
  
  // local item "-"
  local n_ok = _N   
  
  forvalues i = 1/`n_ok'{
  
      dis "`i'.`item' " ref_dis[`i']
   
  }  
  
*-Output as Markdown document
    local path : pwd
    local saving "${filename}.md"
    
    qui export delimited ref_out using `"`path'/`saving'"' , ///
    	       novar nolabel delimiter(tab) replace
    local save "`saving'"   
    	    noi dis " "
    		noi dis _dup(58) "-" _n ///
    				_col(3)  `"{stata `" view  "`path'/`save'" "': View}"' ///
    				_col(17) `"{stata `" !open "`path'/`save'" "' : Open_Mac}"' ///
    				_col(30) `"{stata `" winexec cmd /c start "" "`path'/`save'" "' : Open_Win}"' ///
                    _col(50) `"{browse `"`path'"': dir}"'
            noi dis _dup(58) "-"
 
* ---------------------- over ----------------------- 

* === Results ===

  view browse "https://gitee.com/arlionn/getiref/blob/master/results-Markdown.md"
