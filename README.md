# FHM_replication
 Reproducing FHMs "skattning av det momentana reproduktionstalet"

##  About

Estimating the reproduction number of an active pandemic can be
tough. However, with simple available tools one can produce estimates
that potentially aren't that far from the truth.

However, as for active pandemics, formating the data and tune the
models is usually the problem. In this short code sample, I aim to
show how one can simply reproduce number similar to what the Public
Health Agency Of Sweden has publiced here
[FHM][https://www.folkhalsomyndigheten.se/smittskydd-beredskap/utbrott/aktuella-utbrott/covid-19/statistik-och-analyser/analys-och-prognoser/].

## CODE
In short, this is the code needed to replicate their results.
```
config <- make_config(list(mean_si = 4.8,
                           std_si = 2.3))
method <- "parametric_si"
res <- estimate_R(df$incidence,
                  method=method,
                  config = config)
 ```

Which will give you
![FHM replicate](/fig/FHM.png "FHM replicate")
for the region of Uppsala.

See the full code under `/R/` and the data is found in `/data/` the
figures produced can be found under `/fig/`.

## Suggestions
The noisy incidence creates poor estimates, what we can do to address
this we can use (all are for Uppsala, one can change region in the code)
* rolling mean on the data
![Rolling mean](/fig/FHM_roll.png "Rolling mean")
* uncertainty in the gamma distribution.
![Uncertainty in parameters](/fig/FHM_uc.png "uc in param")
* both of the above
![rolling, and uncertainty in parameters](/fig/FHM_uc_roll.png "roll and uc in param")
