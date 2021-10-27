# Web Scraping La Protesta

url_lp <- 'https://americalee.cedinci.org/wp-content/uploads/2018/03/LaProtesta1909_n1559.pdf'

download.file(url_lp, './LaProtesta/1559.pdf')

# función para raspar links

scraping_links <- function(pag_web, tag_link) {   # abro función para raspado web y le asigno un nombre: scraping_links.
  
  read_html(pag_web) %>%                   # llamo a la función read_html() para obtener el contenido de la página.
    
    html_elements(tag_link) %>%            # llamo a la función html_elements() y especifico las etiquetas de los títulos 
    
    html_attr("href") %>%                  # llamo a la función html_attr() para especificar el formato 'chr' del título.
    
    url_absolute(pag_web) %>%              # llamo a la función absolute() para completar las URLs relativas
    
    as_tibble() %>%                        # llamo a la función as_tibble() para transforma el vector en tabla
    
    rename(link = value)                   # llamo a la función rename() para renombrar la variable 'value'
  
}                                          # cierro la función para raspado web

# Usamos la función para scrapear los pdf de La Protesta ----------------------------------------------

(links_lp <- scraping_links(pag_web = "https://americalee.cedinci.org/la-protesta-febrero-1909/", tag_link = "a.fusion-no-lightbox"))

for (i in links_lp$link[1:23]) {
  download.file(i, paste0('./LaProtesta/1909/02/', str_sub(i, 59,82)))
}
