{smcl}
{* *! Version 1.0.2 by Francisco Perales & Reinhard Schunck 09-August-2016}{...}
{bf:help xthybrid}{right: ({browse "http://www.stata-journal.com/article.html?article=up0061":SJ18-4: st0468_1})}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{bf:xthybrid} {hline 2}}Estimate hybrid and correlated random-effects and Mundlak mixed-effects models for linear and nonlinear outcomes


{title:Syntax}

{p 8 16 2}
{cmd:xthybrid} {depvar} {indepvars} {ifin}{cmd:,} {opt c:lusterid(varname)}
[{it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opt c:lusterid(varname)}}specify the cluster or grouping variable{p_end}
{synopt:{opt f:amily(type)}}specify the distribution of the outcome variable{p_end}
{synopt:{opt l:ink(type)}}specify the link function{p_end}
{synopt:{opt cre}}request a correlated random-effects model instead of a hybrid model{p_end}
{synopt:{opt n:onlinearities(type)}}add polynomial functions of the cluster means to the model{p_end}
{synopt:{opt random:slope(varlist)}}request random slopes on the random-effect and within-group coefficients of selected variables{p_end}
{synopt:{opt u:se(varlist)}}split between- and within-cluster effects only for selected explanatory variables{p_end}
{synopt:{opt perc:entage(#)}}set the minimum % within-cluster variance for explanatory variables to be considered cluster varying{p_end}
{synopt:{opt te:st}}present test results of the random-effects assumption for separate model variables{p_end}
{synopt:{opt f:ull}}print the full model output{p_end}
{synopt:{opt st:ats(list)}}allow users to select which model summary statistics are reported{p_end}
{synopt:{opt se}}request standard errors for the parameters on model variables{p_end}
{synopt:{opt t}}request t-values for the parameters on model variables{p_end}
{synopt:{opt p}}request p-values for the parameters on model variables{p_end}
{synopt:{opt star}}request stars to denote statistically significant parameters on model variables{p_end}
{synopt:{opt vce(vcetype)}}specify the type of standard error to be reported{p_end}
{synopt:{opt iterations}}request that the command be executed noisily{p_end}
{synopt:{opt meglm:opts(list)}}enable the user to request options from the {cmd:meglm} command{p_end}
{synoptline}
{pstd}
* {opt clusterid(varname)} is required.


{title:Description}

{pstd}
{cmd:xthybrid} fits linear and nonlinear mixed-effects regression models that
split the effects of cluster-varying covariates on the outcome variable into
within-cluster and between-cluster effects (Schunck 2013; Schunck and Perales
2017).  It accomplishes this by i) specifying cluster-varying variables in
{it:indepvars} as deviations from the cluster mean and ii) adding the cluster
means of the original cluster-varying variables to the model.  In the linear
case, this can be expressed as

{phang}
Y_{ij} = A + B_{1}*Z_{i} + B_{2}*(X_{ij}-X_bar_{i}) + B_{3}*X_bar_{i} + u_{i} + e_{ij}

{pstd}
where B_{2} captures the within-cluster effect of cluster-varying variables on
Y_{ij} and B_{3} captures the between-cluster effect of cluster-varying
variables on Y_{ij}.  This technique, discussed in Allison (2009), is related
to the correlated random-effect model originally proposed by Mundlak (1978),
also known as the Mundlak model.  If no variables vary within clusters,
{cmd:xthybrid} fits a standard mixed-effects model and displays a warning.
The between-cluster effects are given by the cluster-mean variables beginning
with the prefix {cmd:B_}, while the within-cluster effects are given by the
cluster-mean differenced variables beginning with the prefix {cmd:W_}.  Use
the prefix {cmd:R_} to denote variables for which the coefficient is the
"standard" random-effect coefficient.  Stata keeps model estimates in its
background memory to be accessed via {cmd:estimates dir}.

{pstd}
The {cmd:xthybrid} command is an expansion of the {cmd:mundlak} command
(Perales 2013).  However, unlike the latter, it allows for nonlinear models.
Specifically, {cmd:xthybrid} can fit any two-level specification covered by
Stata's {cmd:meglm} command.


{title:Options}
	
{phang}
{opt clusterid(varname)} specifies the variable in the dataset to use as the
cluster or grouping variable (that is, the level 2 ID variable).
{cmd:clusterid()} is required.

{phang}
{opt family(type)} specifies the distribution of the outcome variable.
{it:type} may be {cmd:gaussian}, {cmd:bernoulli}, {cmd:binomial}, {cmd:gamma},
{cmd:nbinomial}, {cmd:ordinal}, or {cmd:poisson}.  The default is
{cmd:family(gaussian)}.

{phang}
{opt link(type)} specifies the link function.  {it:type} may be
{cmd:identity}, {cmd:log}, {cmd:logit}, {cmd:probit}, or {cmd:cloglog}.  The
default is {cmd:link(identity)}.  Note that certain combinations of families
and links are not possible.  Linear models equivalent to those estimated by
{cmd:mundlak} can be fit in {cmd:xthybrid} by specifying the family as
{cmd:gaussian} and the link as {cmd:identity}.  You can accomplish the same by
not specifying either of these options (that is, linear models are the
default).

{phang}
{cmd:cre} fits the model without transforming the original explanatory
variables into cluster-mean deviations.  In practice, when you use this
option, {cmd:xthybrid} fits a correlated random-effects model as described in
Mundlak (1978) (that is, the Mundlak model).  In the linear case, this can be
expressed as
 
{phang2}
Y_{ij} = A + B_{1}*Z_{i} + B_{2}*X_{ij} + B_{3}*X_bar_{i} + v_{ij}

{pmore}
where B_{2} captures the within-cluster effect of cluster-varying variables on
Y_{ij} and B_{3} now captures the difference between the between-cluster and
within-cluster effects of cluster-varying variables on Y_{ij}.  The
within-cluster effects are denoted by variables with the prefix {cmd:B_}, the
differences between the between- and within-cluster effects are denoted by
variables with the prefix {cmd:D_}, and the random effects are denoted by
variables with the prefix {cmd:R_}.

{phang}
{opt nonlinearities(type)} adds polynomial functions of the cluster means to
the model.  {it:type} may be {cmd:quadratic}, {cmd:cubic}, or {cmd:quartic}.

{phang}
{opt randomslope(varlist)} requests that random slopes be estimated on the
random-effect and within-group coefficients of selected variables.  Users need
specify only the name of the original variable.  Note that estimation of these
random-slope models can be time consuming.

{phang}
{opt use(varlist)} specifies the variables for which between- and
within-cluster effects will be displayed in the model.  The default is to use
all the variables in {it:indepvars} that vary within clusters.  If the
variables specified in {cmd:use()} do not vary within clusters, {cmd:xthybrid}
will display a warning.

{phang}
{opt percentage(#)} suppresses the separation of between- and within-cluster
effects of variables for which within-cluster variance accounts for a
percentage of the total variance lower than {it:#}.  The default is
{cmd:percentage(0)}.  If you specify {cmd:use()}, {cmd:xthybrid} will evaluate
the percentage of the total variance that is within clusters for the variables
set in this option.
 
{phang} {cmd:test} presents the test results of the random-effect assumption
for separate explanatory variables.  For the hybrid model, these take the form
{cmd:_b[B_}{it:varname}{cmd:] = _b[W_}{it:varname}{cmd:]}.  When you specify
the {cmd:cre} option, the tests take the form 
{cmd:_b[D_}{it:varname}{cmd:] = 0}.  When you specify the {cmd:test} option
with the {cmd:nonlinearities()} option, the test results of whether the
nonlinear effects are equal to zero are displayed.

{phang}
{cmd:full} requests the full regression output for the fit model.

{phang}
{opt stats(list)} allows users to request a different set of model summary
statistics.  This can include any scalars from Stata's {cmd:meglm} command.

{phang}
{cmd:se} requests the standard errors for the parameters on model variables.
Note that specifying the {cmd:full} option overcomes this.

{phang}
{cmd:t} requests the t-values for the parameters on model variables.  Note
that specifying the {cmd:full} option overcomes this.

{phang}
{cmd:p} requests the p-values for the parameters on model variables.  Note
that specifying the {cmd:full} option overcomes this.

{phang}
{cmd:star} requests stars to denote statistically significant parameters on
model variables at the 95 (5%), 99 (1%), and 99.9 (0.1%) levels.  Specifying
the {cmd:star} option overrules {cmd:se}, {cmd:p}, and {cmd:t}.  Note that
specifying the {cmd:full} option overcomes this.

{phang}
{opt vce(vcetype)} specifies the type of standard error to be reported.
{it:vcetype} may be {cmd:oim}, {cmd:robust}, or {cmdab:cl:uster}
{it:clustervar}.

{phang}
{cmd:iterations} requests that the command be executed noisily.

{phang}
{opt meglmopts(list)} enables the user to request additional options from the
{cmd:meglm} command.  Note that not all such options are compatible with
{cmd:xthybrid} and that error messages produced by {cmd:meglm} will not be
displayed.


{title:Examples}

{phang}
{cmd:. webuse nlswork}{p_end}

{phang}
{cmd:. generate white = race==1 & race!=.}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(gaussian) link(identity)}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(gaussian) link(identity) cre}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) nonlinearities(cubic)}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) use(age)}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) percentage(45)}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) test}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) full}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) stats(N k df_m ll chi2 ll_c chi2_c df_c)}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) se t p}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) star}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) randomslope(age) star}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) randomslope(age) star iterations}{p_end}

{phang}
{cmd:. xthybrid union age south white, clusterid(idcode) family(binomial) link(logit) randomslope(age) cre star}{p_end}


{title:Stored results}

{pstd}
{cmd:xthybrid} returns in {cmd:e()} the same results as {cmd:meglm} because
{cmd:xthybrid} relies on {cmd:meglm}.  See {manhelp meglm ME} for details.

		
{title:References}

{phang}
Allison, P. D. 2009. {it:Fixed Effects Regression Models}. Thousand Oaks, CA:
Sage.
 
{phang}
Mundlak, Y. 1978. On the pooling of time series and cross section data.
{it:Econometrica} 46: 69-85.

{phang}
Perales, F. 2013. mundlak: Stata module to estimate random-effects regressions
adding group-means of independent variables to the model. Statistical Software
Components S457601, Department of Economics, Boston College. 
{browse "http://econpapers.repec.org/software/bocbocode/s457601.htm"}.
 
{phang}
Schunck, R. 2013. Within and between estimates in random-effects models: Advantages and drawbacks of correlated random effects and hybrid models.
{it:Stata Journal} 13: 65-76
 
{phang}
Schunck, R., and F. Perales. 2017. {browse "http://www.stata-journal.com/article.html?article=st0468":Within- and between-cluster effects in generalized linear mixed models: A discussion of approaches and the xthybrid command}. 
{it:Stata Journal} 17: 89-115.
 

{title:Authors}

{pstd}Francisco Perales{break}
Institute for Social Science Research{break}
University of Queensland{break}
Brisbane, Australia{break}
f.perales@uq.edu.au{p_end}
	
{pstd}Reinhard Schunck{break}
GESIS -- Leibniz-Institute for the Social Sciences{break}
Cologne, Germany{break}
reinhard.schunck@gesis.org{p_end}
	

{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 18, number 4: {browse "http://www.stata-journal.com/article.html?article=up0061":st0468_1}{break}
          {it:Stata Journal}, volume 17, number 1: {browse "http://www.stata-journal.com/article.html?article=st0468":st0468}{p_end}

{p 5 14 2}
Manual:  {manlink ME meglm}

{p 7 14 2}
Help:  {helpb mundlak} (if installed){p_end}
