# FHM_replication
 Reproducing FHMs "skattning av det momentana reproduktionstalet"

##  About
The idea behind this repo is to show how little effort FHM put into their R-estimate.

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

See the full code under `/R/` and the data is found in `/data/` the
figures produced can be found under `/fig/`.

## Suggestions
The noisy incidence creates poor estimates, what we can do to address
this we can use
* rolling mean on the data
![Rolling mean](/fig/FHM_roll.png "Rolling mean")
* uncertainty in the gamma distribution.
![Uncertainty in parameters](/fig/FHM_uc.png "uc in param")
* both of the above
![rolling, and uncertainty in parameters](/fig/FHM_uc_roll.png "roll and uc in param")