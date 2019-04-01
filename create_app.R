# app delpoyment
require(RInno)
require(here)
require(installr)

libraries <- c(
  "datasets",
  "rlang"
)

install.inno(quick_start_pack = TRUE) 

create_app(
  app_name = "test_app_deployment", 
  app_dir = here(),
  pkgs = libraries,
  include_R = TRUE,
  default_dir = "pf"
)

compile_iss()