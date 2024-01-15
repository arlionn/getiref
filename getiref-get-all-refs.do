```stata
*----------------------------------------
*----------------------------------------
*
* Obtain citation information for all references of a paper
*
*----------------------------------------
*----------------------------------------
*  Including:
*    Citation links,
*    PDFs,
*    .ris / .bibtex files for importing into reference management software such as Endnote, etc.

* Author: Yujun Lian, arlionn@163.com, 2024/1/13 9:38
*
* Repository:
  view browse "https://gitee.com/arlionn/getiref"
  
  
  
*============ A. Parameter Settings ================ begin ======

*-~~~~~~~~~ Enter the DOI of the paper to be retrieved here ~~~~~~~~~~~~~(!!!! important !!!! )
   
//   global DOI "10.1257/aer.109.4.1197" 
//   global DOI "10.1177/1536867X20953574"      // SJ 
  global DOI "10.1016/j.jfineco.2017.04.001" // JFE, 70 refs
//   global DOI "10.1016/j.econlet.2021.110063" // Eco Letters, 2022, 6 refs 

*-Download PDF files and .ris, .bibtex documents
  global pdf "pdf"
//   global bib "bib"
  global bib ""
  global md  "md"   // Alternative: text, latex 
  
* Clear screen (optional, comment out if not needed)
  cls 

*-Storage path: Name of the directory to store PDF files (automatically creates a new one if it doesn't exist)
  global Root "D:/_temp_getiref" 
  qui getiref $DOI, path($Root)
  global filename "`r(author1)'_`r(year)'"
  global path "$Root/$filename"  // Folder for jth paper
  !md "$path"
  cd  "$path"   
  
*============ A. Parameter Settings ================ over =======

*-Install the getiref command (ignore these two lines if already installed)
  cap which cnssc
  if _rc   ssc install cnssc, replace 
  cap which getiref
  if _rc   cnssc install getiref, replace 

*-Retrieve data and save as .txt and .dta files
  //   local type "citations"  // Citations, temporarily unavailable
  local type "references"   // References
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
      else{ // Categorize error messages, some are unable to get bib, some are unable to get PDF
          qui replace fail = 1 in `i'
          dis as error "failed to get metadata for {DOI}: `doi'"
      }
  }  
     
     
*---------------------
*- Display and Export 
*---------------------

* Note: This part can be executed repeatedly to quickly reproduce results
  sort ref_out 
  
  // local item "-"
  local n_ok = _N   
  
  forvalues i = 1/`n_ok'{
  
      noi dis "`i'.`item' " ref_dis[`i']
   
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
    				_skip(4) `"{stata `" !open "`path'/`save'" "'
