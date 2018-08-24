{smcl}
{* *! version 1 21aug2018}{...}
{findalias asfradohelp}{...}
{viewerjumpto "Examples" "ccodes##examples"}{...}
{title:Title}

{phang}
{bf:ccodes} {hline 2} convert country codes or country names


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:ccodes}
[{varname}]
{ifin}
{cmd:,} {it:from()} {it:to()} [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt from()}}indicate the coding scheme of the data that is to be converted{p_end}
{synopt:{opt to()}}indicate the coding scheme to which the data is to be converted{p_end}
{syntab:Auxiliary}
{synopt:{opth gen:erate(newvar)}}create variable name {it:newvar}{p_end}
{synopt:{opt nodet:ails}}do not display summary of unmatched observations{p_end}
{synopt:{opt sval:ue()}}display the result for a single value{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Note: Underlining indicates minimal abbreviation.{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:ccodes} converts the data in {varname} or {cmd:svalue()} to and from (i) numeric country codes, (ii) alpha-3 country codes, and (iii) country names
for the following country coding schemes: Correlates of War (COW), International Organization for Standardization (ISO), and Polity IV (P4).

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt from()} Indicates the country coding scheme of the data that is to be converted. The accepted arguments
are: {it:cow_ccode, cow_scode, cow_name, iso_scode, iso_name, p4_ccode, p4_scode}, and {it:p_name}. {it:*_ccode} is
a three-digit numeric country code, {it:*_scode} a three-letter alpha country code, and {it:*_name} is the alpha
country name for each of the three country coding schemes. This option is required.

{phang}
{opt to()} Indicates the country coding scheme to which the data is to be converted. It takes
the same arguments as the option {cmd:from()} above. The only restriction is that the arguments of {cmd:from()} and
{cmd:to()} cannot be the same. This option is required.

{dlgtab:Auxiliary}

{phang}
{opt generate} Creates {it:newvar} containing the code conversions. If not specified, the new variable is named
after option {cmd:to()}'s argument (e.g., cow_name, iso_scode, p4_ccode, etc.). It cannot be combined with {cmd:svalue()}.

{phang}
{opt nodetails} Suppresses the summary list of unmatched observations in {varname} or {cmd:svalue()}. By default, the program displays this output.

{phang}
{opt svalue()} Posts the code conversion for a single value instead of for an entire variable. It cannot be combined
with {cmd:generate()}. Either {cmd:svalue()} or {varname} must be specified, but not both.

{marker remarks}{...}
{title:The interactive {cmd:ccodes} command}

{pstd}
This is an online command that requires no installation of the {ado ccodes.ado} file. To use it, first
save the intended command, enclosed in quotes, in a scalar called {it:cmd_ccodes} (see {cmd:Example 2} below). Second, run the following
command:

{pstd}
{inp:run https://dl.dropboxusercontent.com/s/7yoddi10lhyib2j/stata_ccodes.do?dl=0}

{marker remarks}{...}
{title:Remarks}

{pstd}
Country names can be written with or without accents (e.g., C{char 244}te d'Ivoire or Cote d'Ivoire),
employing either capitalized or lower case letters  (e.g., cote d'ivoire, COTE D'IVOIRE, or CoTe d'IvOiRe).

{marker examples}{...}
{title:Examples}

{pstd}
{bf:Example 1}

{phang}{cmd:. use ccodes_example.dta, clear}{p_end}
{phang}{cmd:. list in 1/5}{p_end}
{phang}{cmd:. ccodes, from(p4_name) to(iso_scode) sval(Estonia)}{p_end}
{phang}{cmd:. ccodes polity_country, from(p4_name) to(cow_ccode) gen(numeric)}{p_end}
{phang}{cmd:. ccodes numeric, from(cow_ccode) to(iso_scode) nodet}{p_end}
{phang}{cmd:. list in 1/5}{p_end}

{pstd}
{bf:Example 2}

{phang}{cmd:. use ccodes_example.dta, clear}{p_end}
{phang}{cmd:. list in 1/5}{p_end}
{phang}{cmd:. ccodes polity_country, from(p4_name) to(cow_ccode) gen(numeric)}{p_end}
{phang}{cmd:. scalar cmd_ccodes = "ccodes polity_country, from(p4_name) to(cow_ccode) gen(webvar) nodet"}{p_end}
{phang}{cmd:. run https://dl.dropboxusercontent.com/s/7yoddi10lhyib2j/stata_ccodes.do?dl=0}{p_end}
{phang}{cmd:. list in 1/5}{p_end}
