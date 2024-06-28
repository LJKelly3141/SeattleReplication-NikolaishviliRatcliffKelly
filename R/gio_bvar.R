bvar <- function(
    data, 
    lags,
    n_draw = 10000L, 
    n_burn = 5000L, 
    n_thin = 1L,
    priors = bv_priors(),
    mh = bv_mh(),
    fcast = NULL,
    irf = NULL,
    verbose = TRUE, ...) {
  
  cl <- match.call()
  start_time <- Sys.time()
  
  
  # Setup and checks -----
  
  # Data
  if(!all(vapply(data, is.numeric, logical(1L))) ||
     any(is.na(data)) || ncol(data) < 2) {
    stop("Problem with the data. Make sure it is numeric, without any NAs.")
  }
  
  Y <- as.matrix(data)
  
  # Integers
  lags <- BVAR:::int_check(lags, min = 1L, max = nrow(Y) - 1, msg = "Issue with lags.")
  n_draw <- BVAR:::int_check(n_draw, min = 10L, msg = "Issue with n_draw.")
  n_burn <- BVAR:::int_check(n_burn, min = 0L, max = n_draw - 1L,
                      msg = "Issue with n_burn. Is n_burn < n_draw?")
  n_thin <- BVAR:::int_check(n_thin, min = 1L, max = ((n_draw - n_burn) / 10),
                      msg = "Issue with n_thin. Maximum allowed is (n_draw - n_burn) / 10.")
  n_save <- BVAR:::int_check(((n_draw - n_burn) / n_thin), min = 1L)
  verbose <- isTRUE(verbose)
  
  # Constructors, required
  if(!inherits(priors, "bv_priors")) {
    stop("Please use `bv_priors()` to configure the priors.")
  }
  if(!inherits(mh, "bv_metropolis")) {
    stop("Please use `bv_mh()` to configure the Metropolis-Hastings step.")
  }
  # Not required
  if(!is.null(fcast) && !inherits(fcast, "bv_fcast")) {
    stop("Please use `bv_fcast()` to configure forecasts.")
  }
  if(!is.null(irf) && !inherits(irf, "bv_irf")) {
    stop("Please use `bv_irf()` to configure impulse responses.")
  }
  
  if(mh[["adjust_acc"]]) {n_adj <- as.integer(n_burn * mh[["adjust_burn"]])}
  
  
  # Preparation ---
  
  X <- BVAR:::lag_var(Y, lags = lags)
  
  Y <- Y[(lags + 1):nrow(Y), ]
  X <- X[(lags + 1):nrow(X), ]
  X <- cbind(1, X)
  XX <- crossprod(X)
  
  K <- ncol(X)
  M <- ncol(Y)
  N <- nrow(Y)
  
  variables <- BVAR:::name_deps(variables = colnames(data), M = M)
  explanatories <- BVAR:::name_expl(variables = variables, M = M, lags = lags)
  
  
  # Priors -----
  
  # Minnesota prior ---
  
  b <- priors[["b"]]
  if(length(b) == 1 || length(b) == M) {
    priors[["b"]] <- matrix(0, nrow = K, ncol = M)
    priors[["b"]][2:(M + 1), ] <- diag(b, M)
  } else if(!is.matrix(b) || !all(dim(b) == c(K, M))) {
    stop("Issue with the prior mean b. Please reconstruct.")
  }
  
  if(any(priors[["psi"]][["mode"]] == "auto")) {
    psi_temp <- BVAR:::auto_psi(Y, lags)
    priors[["psi"]][["mode"]] <- psi_temp[["mode"]]
    priors[["psi"]][["min"]] <- psi_temp[["min"]]
    priors[["psi"]][["max"]] <- psi_temp[["max"]]
  }
  if(!all(vapply(priors[["psi"]][1:3],
                 function(x) length(x) == M, logical(1L)))) {
    stop("Dimensions of psi do not fit the data.")
  }
  
  # Parameters ---
  pars_names <- names(priors)[ # Exclude reserved names
    !grepl("^hyper$|^var$|^b$|^psi[0-9]+$|^dummy$", names(priors))]
  pars_full <- do.call(c, lapply(pars_names, function(x) priors[[x]][["mode"]]))
  names(pars_full) <- BVAR:::name_pars(pars_names, M)
  
  
  # Hierarchical priors ---
  hyper_n <- length(priors[["hyper"]]) +
    sum(priors[["hyper"]] == "psi") * (M - 1)
  if(hyper_n == 0) {stop("Please provide at least one hyperparameter.")}
  
  get_priors <- function(name, par) {priors[[name]][[par]]}
  hyper <- do.call(c, lapply(priors[["hyper"]], get_priors, par = "mode"))
  hyper_min <- do.call(c, lapply(priors[["hyper"]], get_priors, par = "min"))
  hyper_max <- do.call(c, lapply(priors[["hyper"]], get_priors, par = "max"))
  names(hyper) <- BVAR:::name_pars(priors[["hyper"]], M)
  
  # Split up psi ---
  for(i in seq_along(priors[["psi"]][["mode"]])) {
    priors[[paste0("psi", i)]] <- vapply(c("mode", "min", "max"), function(x) {
      priors[["psi"]][[x]][i]}, numeric(1L))
  }
  
  
  # Optimise and draw -----
  
  opt <- optim(par = hyper, BVAR:::bv_ml, gr = NULL,
               hyper_min = hyper_min, hyper_max = hyper_max, pars = pars_full,
               priors = priors, Y = Y, X = X, XX = XX, K = K, M = M, N = N, lags = lags,
               opt = TRUE, method = "L-BFGS-B", lower = hyper_min, upper = hyper_max,
               control = list("fnscale" = -1))
  
  names(opt[["par"]]) <- names(hyper)
  
  if(verbose) {
    cat("Optimisation concluded.",
        "\nPosterior marginal likelihood: ", round(opt[["value"]], 3),
        "\nHyperparameters: ", paste(names(hyper), round(opt[["par"]], 5),
                                     sep = " = ", collapse = "; "), "\n", sep = "")
  }
  
  
  # Hessian ---
  
  if(length(mh[["scale_hess"]]) != 1 &&
     length(mh[["scale_hess"]]) != length(hyper)) {
    stop("Length of scale_hess does not match the ", length(hyper),
         " hyperparameters. Please provide a scalar or an element for every ",
         "hyperparameter (see `?bv_mn()`).")
  }
  
  H <- diag(length(opt[["par"]])) * mh[["scale_hess"]]
  J <- unlist(lapply(names(hyper), function(name) {
    exp(opt[["par"]][[name]]) / (1 + exp(opt[["par"]][[name]])) ^ 2 *
      (priors[[name]][["max"]] - priors[[name]][["min"]])
  }))
  if(any(is.nan(J))) {
    stop("Issue with parameter(s) ",
         paste0(names(hyper)[which(is.nan(J))], collapse = ", "), ". ",
         "Their mode(s) may be too large to exponentiate.")
  }
  if(hyper_n != 1) {J <- diag(J)}
  HH <- J %*% H %*% t(J)
  
  # Make sure HH is positive definite
  if(hyper_n != 1) {
    HH_eig <- eigen(HH)
    HH_eig[["values"]] <- abs(HH_eig[["values"]])
    HH <- HH_eig
  } else {HH <- list("values" = abs(HH))}
  
  
  # Initial draw ---
  
  while(TRUE) {
    hyper_draw <- BVAR:::rmvn_proposal(n = 1, mean = opt[["par"]], sigma = HH)[1, ]
    ml_draw <- BVAR:::bv_ml(hyper = hyper_draw,
                     hyper_min = hyper_min, hyper_max = hyper_max, pars = pars_full,
                     priors = priors, Y = Y, X = X, XX = XX, K = K, M = M, N = N, lags = lags)
    if(ml_draw[["log_ml"]] > -1e16) {break}
  }
  
  
  # Sampling -----
  
  # Storage ---
  accepted <- 0 -> accepted_adj # Beauty
  ml_store <- vector("numeric", n_save)
  hyper_store <- matrix(NA, nrow = n_save, ncol = length(hyper_draw),
                        dimnames = list(NULL, names(hyper)))
  beta_store <- array(NA, c(n_save, K, M))
  sigma_store <- array(NA, c(n_save, M, M))
  
  if(verbose) {pb <- txtProgressBar(min = 0, max = n_draw, style = 3)}
  
  # Start loop ---
  for(i in seq.int(1 - n_burn, n_draw - n_burn)) {
    
    # Metropolis-Hastings
    hyper_temp <- BVAR:::rmvn_proposal(n = 1, mean = hyper_draw, sigma = HH)[1, ]
    ml_temp <- BVAR:::bv_ml(hyper = hyper_temp,
                     hyper_min = hyper_min, hyper_max = hyper_max, pars = pars_full,
                     priors = priors, Y = Y, X = X, XX = XX, K = K, M = M, N = N, lags = lags)
    
    # Draw parameters, i.e. beta_draw and sigma_draw
    # These need X and N with the dummy observations from `ml_draw`
    draws <- BVAR:::draw_post(XX = ml_draw[["XX"]], N = ml_draw[["N"]],
                              M = M, lags = lags, b = priors[["b"]], psi = ml_draw[["psi"]],
                              sse = ml_draw[["sse"]], beta_hat = ml_draw[["beta_hat"]],
                              omega_inv = ml_draw[["omega_inv"]])
    
    # Test sign and magnitude restrictions!
    ## Get impact matrix
    impact_mat <- draws[["sigma_draw"]] |> chol() |> t() 
    
    ## Transform residuals by `impact_mat` to get
    ## "structural" shock paths 
    reduced_resids <- Y - X %*% draws[["beta_draw"]]
    struct_resids <- solve(impact_mat) %*% t(reduced_resids)
    struct_resids <- struct_resids |> t()
    w1 = struct_resids[,1]
    
    ## Test for sign & magnitude restrictions 
    ## + likelihood 
      if(w1[118-lags] < 0 && 
         w1[119-lags] > 0 && 
         w1[154-lags] > 0 && 
         w1[155-lags] < 0 && 
         abs(w1[155-lags]) > 0.5 * abs(reduced_resids[155-lags]) && 
         runif(1) < exp(ml_temp[["log_ml"]] - ml_draw[["log_ml"]])) { # Accept
        ml_draw <- ml_temp
        hyper_draw <- hyper_temp
        accepted_adj <- accepted_adj + 1
        if(i > 0) {accepted <- accepted + 1}
      }
    
    # Tune acceptance during burn-in phase
    if(mh[["adjust_acc"]] && i <= -n_adj && (i + n_burn) %% 10 == 0) {
      acc_rate <- accepted_adj / (i + n_burn)
      if(acc_rate < mh[["acc_lower"]]) {
        HH[["values"]] <- HH[["values"]] * mh[["acc_tighten"]]
      } else if(acc_rate > mh[["acc_upper"]]) {
        HH[["values"]] <- HH[["values"]] * mh[["acc_loosen"]]
      }
    }
    
    if(i > 0 && i %% n_thin == 0) { # Store draws
      
      ml_store[(i / n_thin)] <- ml_draw[["log_ml"]]
      hyper_store[(i / n_thin), ] <- hyper_draw
      
      beta_store[(i / n_thin), , ] <- draws[["beta_draw"]]
      sigma_store[(i / n_thin), , ] <- draws[["sigma_draw"]]
      
    } # End store
    
    if(verbose) {setTxtProgressBar(pb, (i + n_burn))}
    
  } # End loop
  
  timer <- Sys.time() - start_time
  
  if(verbose) {
    close(pb)
    cat("Finished MCMC after ", format(round(timer, 2)), ".\n", sep = "")
  }
  
  
  # Outputs -----
  
  out <- structure(list(
    "beta" = beta_store, "sigma" = sigma_store,
    "hyper" = hyper_store, "ml" = ml_store,
    "optim" = opt, "priors" = priors, "call" = cl,
    "variables" = variables, "explanatories" = explanatories,
    "meta" = list("accepted" = accepted, "timer" = timer,
                  "Y" = Y, "X" = X, "N" = N, "K" = K, "M" = M, "lags" = lags,
                  "n_draw" = n_draw, "n_burn" = n_burn, "n_save" = n_save,
                  "n_thin" = n_thin)
  ), class = "bvar")
  
  if(!is.null(irf)) {
    if(verbose) {cat("Calculating impulse responses.")}
    out[["irf"]] <- tryCatch(irf.bvar(out, irf), error = function(e) {
      warning("\nImpulse response calculation failed with:\n", e)
      return(NULL)})
    if(verbose) {cat("..Done!\n")}
  }
  if(!is.null(fcast)) {
    if(verbose) {cat("Calculating forecasts.")}
    out[["fcast"]] <- tryCatch(predict.bvar(out, fcast), error = function(e) {
      warning("\nForecast calculation failed with:\n", e)
      return(NULL)})
    if(verbose) {cat("..Done!\n")}
  }
  
  return(out)
}