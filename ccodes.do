qui {
capture program drop ccodes
program ccodes
//version 15 // 14 and above only
	
	syntax [varname(default=none)] [if] [in] , from(string) to(string) [GENerate(string) SVALue(string) year(string)]

qui {

	local csets = "p4_ccode p4_scode p4_country cow_ccode cow_scode cow_country iso_scode iso_country"
	
	if "`varlist'"!= "" & "`svalue'"!= "" {
		di as err "{bf:varname} cannot be combined with {bf:svalue()}"
		exit
	}
	
	if "`from'"!= "" { // from and to THEY CANNOT BE MISSING
	
		if "`to'"=="`from'" {
			di as error "{bf:from()}'s and {bf:to()}'s arguments cannot be the same."
			exit
		}
	
		local exit = 0
		foreach c of local csets {
			if "`c'"=="`from'" {			
				local exit = 1
				continue, break
			}
		}
		if `exit'==0 {
			di as error "{bf:from()}'s argument {it:`from'} unrecognized."
			di as error "Currently accepted code sets are: {it:`csets'}."
			exit
		}
	}
	
	if "`to'"!= "" {
	
		local exit = 0
		foreach c of local csets {
			if "`c'"=="`to'" {			
				local exit `exit'+1
				continue, break
			}
		}
		if `exit'==0 {
			di as error "{bf:to()}'s argument {it:`to'} unrecognized."
			di as error "Currently accepted code sets are: {it:`csets'}."
			exit
		}
	}

	if "`generate'"!= "" & "`svalue'"!= "" {
		di as err "{bf:generate()} cannot be combined with {bf:svalue()}"
		exit
	}

	if "`year'"!= "" {
		confirm variable `year'
		tempvar y
		capture confirm string variable `year'
		if rc==0 {
			destring `year', generate(`y') force
		}
		else {
			gen `y' = `year'
		}
		if length(string(`y'[1]))!=4 di as err "four-digit year date format if required for the {bf:year()} variable"
	}
			
	tempvar Nseq
	egen `Nseq' = seq()

	preserve
	tempfile codes
	import excel csets, first clear
	tempvar `from' `to'
	rename `from' ``from''
	rename `to' ``to''
	save "`codes'"
	restore
	merge 1:1 _n using "`codes'", keepusing(``from'' ``to'') nogen

	if "`svalue'"!="" {

		local n = 0
		capture confirm number `svalue'
		if _rc==0 {

			capture confirm string variable ``from''
			if _rc==0 {
				di as err "{bf:from()}'s argument must be numeric if {bf:svalue()}'s argument is numeric."
				exit
			}

			tempvar seq
			egen `seq' = seq() if ``from''!=.
			sort `seq'
			sum `seq', meanonly
			forval i = 1/`r(max)' {
				if `svalue'==``from''[`i'] {
					noi di as text _newline ``to''[`i']
					local n = 1
				}
			}	
		}
		else {

			capture confirm string variable ``from''
			if _rc!=0 {
				di as err "{bf:from()}'s argument must be string if {bf:svalue()}'s argument is string."
				exit
			}

			local single = trim(ustrto(ustrnormalize(ustrlower("`svalue'","en"), "nfd"), "ascii", 2))
			tempvar seq
			egen `seq' = seq() if ``from''!=""
			sort `seq'
			sum `seq', meanonly
			forval i = 1/`r(max)' {
				if "`single'"==ustrto(ustrnormalize(ustrlower(``from''[`i'],"en"), "nfd"), "ascii", 2) {
					noi di as text _newline ``to''[`i']
					local n = 1
				}
			}
		}
		if `n'==0 noi di as text _newline "no {it:`to'} match found for {it:`from': `svalue'}"
		
		keep if `Nseq'!=.
		sort `Nseq'
	}
	
	else {
		
		if "`varlist'"=="" {
			di as err "either {bf:varname} or {bf:svalue} must be specified"
			exit
		}
		
		tempvar tvar seq
		capture confirm string variable `varlist'
		if _rc==0 {
			gen `tvar' = trim(ustrto(ustrnormalize(ustrlower(`varlist',"en"), "nfd"), "ascii", 2))
			
			if "`if'"!="" {
				egen `seq' = seq() `if' & `tvar'!="" `in'
			}
			else {
				egen `seq' = seq() if `tvar'!="" `in'
			}
		}
		else {
			gen `tvar' = `varlist'
			
			if "`if'"!="" {
				egen `seq' = seq() `if' & `tvar'!=. `in'
			}
			else {
				egen `seq' = seq() if `tvar'!=. `in'
			}
		}

	// !!! request year for a specific "from" or "to"

		tempvar res
		confirm string variable ``to''
		if _rc==0 {	
			gen `res' = ""
		}
		else {
			gen `res' = .
		}

		local m = 0
		sort `seq'
		sum `seq', meanonly
		forval i = 1/`r(max)' {
			capture replace `res' = ``to'' if `tvar'[`i']==``from'' in `i'
			capture if `tvar'[`i']!=. & `res'[`i']==.  local m = 1
			capture replace `res' = ``to'' if `tvar'[`i']==ustrto(ustrnormalize(ustrlower(``from'',"en"), "nfd"), "ascii", 2) in `i'
			capture if `tvar'[`i']!="" & `res'[`i']=="" local m = 1
		}

		keep if `Nseq'!=.
		sort `Nseq'
		if `m' > 0 {
			noi di as text _newline "List of {it:`from'} entries from the {bf:`varlist'} variable without a {it:`to'} match"
			capture tab `varlist' if `tvar'!="" & `res'==""
			capture tab `varlist' if `tvar'!=.  & `res'==.
		}

		if "`generate'"!="" {
			rename `res' `generate'
		}
		else {
			rename `res' `to'
		}
	}
}

end

noi `=scalar(cmd)'
}
exit
