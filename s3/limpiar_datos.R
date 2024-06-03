# cargar paquetes
suppressPackageStartupMessages(require(tidyverse))

# leer datos
datos <- readr::read_csv("./conjunto_de_datos_defunciones_registradas_2021.csv", 
                         show_col_types = FALSE,
                         col_select = c(ent_resid, mun_resid, causa_def,
                                        sexo, anio_ocur, anio_nacim,
                                        lengua))
directorio <- tribble(~CVE_ENT, ~ENTIDAD,
                      "01", "AGUASCALIENTES",
                      "02", "BAJA CALIFORNIA",
                      "03", "BAJA CALIFORNIA SUR",
                      "04", "CAMPECHE",
                      "05", "COAHUILA DE ZARAGOZA",
                      "06", "COLIMA",
                      "07", "CHIAPAS",
                      "08", "CHIHUAHUA",
                      "09", "CIUDAD DE MEXICO",
                      "10", "DURANGO",
                      "11", "GUANAJUATO",
                      "12", "GUERRERO",
                      "13", "HIDALGO",
                      "14", "JALISCO",
                      "15", "MEXICO",
                      "16", "MICHOACAN DE OCAMPO",
                      "17", "MORELOS",
                      "18", "NAYARIT",
                      "19", "NUEVO LEON",
                      "20", "OAXACA",
                      "21", "PUEBLA",
                      "22", "QUERETARO DE ARTEAGA",
                      "23", "QUINTANA ROO",
                      "24", "SAN LUIS POTOSI",
                      "25", "SINALOA",
                      "26", "SONORA",
                      "27", "TABASCO",
                      "28", "TAMAULIPAS",
                      "29", "TLAXCALA",
                      "30", "VERACRUZ DE IGNACIO DE LA LLAVE",
                      "31", "YUCATAN",
                      "32", "ZACATECAS",
                      "33", "ENTIDAD FEDERATIVA NO ESPECIFICADA")


# lee argumentos desde la línea de comandos
args <- commandArgs(trailingOnly = TRUE)
estado <- args[1]

# obtener unicamente defunciones relacionadas con cáncer (i.e. Aquellas cuya clave empieza con "C")
datos |> 
  dplyr::filter(stringr::str_detect(datos$causa_def, "C")) |> 
  # emparejar dataset con el directorio
  dplyr::left_join(directorio, by = join_by(ent_resid == CVE_ENT)) |> 
  # filtrar un estado de la república
  dplyr::filter(ENTIDAD == estado) |>
  # escribir archivo de salida
  readr::write_csv("./datos_filtrados.csv")

# obtener defunciones relacionadas con cáncer a nivel nacional
datos |> 
  dplyr::filter(stringr::str_detect(datos$causa_def, "C")) |>
  # emparejar dataset con el directorio
  dplyr::left_join(directorio, by = join_by(ent_resid == CVE_ENT)) |> 
  # escribir archivo de salida
  readr::write_csv("./nacional_filtrados.csv")
