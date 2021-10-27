# Web Scraping en R con el paquete rvest

## ¿Qué es el Web Scraping?

Se denomina ‘web scraping’ (en inglés = arañado o raspado web) a la
extracción (automatizada y dirigida) y almacenamiento computacional del
contenido de páginas web. La información raspada puede ser de diverso
tipo. Por ejemplo, contactos telefónicos, correo electrónico,
direcciones físicas, información censal, notas periodísticas o de
opinión, comentarios de lectorxs, precios, etc. Esta información se
almacena en formatos diversos: vectores lógicos, numéricos o de texto
plano, marcos de datos, tablas, listas, matrices, arrays. Los objetos de
clase arrays son poco usuales. En este encuentro nos vamos a centrar en
los objetos de tipo tabular (tibbles y data frames). También usaremos
objetos de clase lista y vector.

![](https://estudiosmaritimossociales.org/Data_TalleR/tipos_objetos_r.png)

En términos generales, el web scraping toma información web
semi-estructurada y la devuelve en un formato estructurado. Como
dijimos, aquí usaremos el formato tibble.

## Web Scraping y el giro digital

En las últimas dos décadas el crecimiento de la información online se
dio de forma acelerada, al punto de tornar imprescindible el uso del
raspado web para la recuperación masiva de parte de esa información
nacida digital. Internet alberga una cantidad infinita de datos
“extraibles”. Parte de esta información subyace en bases de datos,
detrás de API o en texto plano enmarcados en estructuras HTML/XML. Como
vimos en los encuentros anteriores, por distintas razones podemos querer
obtener información de redes sociales como Twitter o de foros de
usuarixs para ver qué está pensando la población sobre distintos temas y
tópicos. De todas formas, la accesibilidad no siempre está al alcance de
la mano, muchas páginas web bloquean el acceso mediante programación o
configuran “muros de pago” que requieren que se suscriba a una API para
acceder. Esto es lo que hacen, por ejemplo, *The New York Times* y *El
ABC*. Pero, finalmente, esas medidas no son una traba definitiva.
Existen muchas formas para obtener los datos que nos interesan.

## ¿Cuándo se usa el Web Scraping?

-   Cuando no hay un conjunto de datos disponible para la problemática
    que queremos abordar.
-   Cuando no hay una API (interfaz de programación de aplicaciones)
    pública disponible que permita un intercambio fluido con los datos
    que necesitamos recopilar. Si el sitio web ofrece una API que
    contiene la información que necesitamos, utilizarla es lo más
    ventajoso. Las APIs permiten recopilar datos en forma rápida y
    directa desde la base de datos detrás del sitio web que tiene la
    información que nos interesa.

Puede ocurrir que algunos sitios tengan información en formatos
inusuales que los hace más difíciles de recopilar. Vale la pena
verificar si puede descargar y extraer información de una sola página
antes de lanzar un raspado completo del sitio web.

## El Web Scraping y su legalidad

En términos generales, el raspado web (no comercial) de información
publicada en la web y de acceso público no es ilegal. Sin embargo,
existen protocolos de buenas prácticas de raspado que debemos intentar
respetar por cuestiones éticas. Para más detalles sobre este asunto
pueden leer los siguientes artículos: James Phoenix (2020) [‘Is Web
Scraping Legal?’](https://understandingdata.com/is-web-scraping-legal/),
Tom Waterman (2020) [‘Web scraping is now
legal’](https://medium.com/@tjwaterman99/web-scraping-is-now-legal-6bf0e5730a78),
Krotov, V., Johnson, L., & Silva, L. (2020) [‘Tutorial: Legality and
Ethics of Web
Scraping’](https://aisel.aisnet.org/cgi/viewcontent.cgi?article=4240&context=cais),
Edward Roberts (2018) [‘Is Web Scraping Illegal? Depends on What the
Meaning of the Word
Is’](https://www.imperva.com/blog/is-web-scraping-illegal/).

## ¿Para qué hacer Web Scraping?

Los usos del raspado web son infinitamente variados. Todo depende del
problema que queramos resolver. Puede ser la recuperación de la serie
histórica de precios de los pasajes de autobús en la ciudad de Mar del
Plata. O el análisis de las tendencias actuales en las agendas
periodísticas en la prensa española. Quizás la detección de cambios en
el lenguaje a lo largo del tiempo referido al uso del lenguaje
inclusivo, por ejemplo. O el monitoreo del humor social en determinado
lugar y tiempo en torno a tópicos políticos, sociales, culturales o
económicos. Etcétera. Etcétera. Etcétera. O el análisis de la
conflictividad social visibilizada en la prensa online, que es lo que
nos ocupa.

Todo esto es independiente de la herramienta que usemos para hacer el
raspado web. Pero no es así en este TalleR 😉.

## ¿Cómo hacer Web Scraping en R?

Esta pregunta la vamos a responder con un enfoque práctico, gracias a
las funciones del paquete `rvest`.

Lo primero que vamos a hacer es activar los paquetes que vamos a
utilizar a lo largo de los ejercicios. El primero de los ejercicios nos
permitirá desarrollar una función de web scraping. En este caso
aplicaremos la función creada a un diario español: *El Mundo*. La
función nos permitirá quedarnos con los titulares de una de sus
secciones. Luego analizaremos esos titulares con técnicas de
tonkenización y, finalmente, visualizaremos los resultados con `ggplot2`
que nos devolverá un gráfico de barras con las palabras más frecuentes.
Esto nos permitirá tener un primer pantallazo sobre la agenda
periodística del periódico en cuestión. Sin más preámbulo, pasemos la
primer ejercicio.

### Ejercicio 1

¿Cuáles son los tópicos más importantes de la agenda del diario *El
Mundo* según las últimas notas de su sección ‘España’? Veamos:

    # Pueden copiar y pegar el script o descargarlo desde RStudio con esta línea de comando:
    # utils::download.file("https://estudiosmaritimossociales.org/ejercicio01.R", "ejercicio01.R")
    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(tidyverse)
    require(rvest)
    require(stringr)
    require(tidytext)
    # Creamos la función para raspar El Mundo cuyo nombre será 'scraping_EM()' ------------------------
    scraping_EM <- function (x){          # abro función para raspado web y le asigno un nombre: scraping_EM
      
      rvest::read_html(x) %>%             # llamo a la función read_html() para obtener el contenido de la página
        
        rvest::html_elements(".ue-c-cover-content__headline-group") %>%  # llamo a la función html_elements() y especifico las etiquetas de los títulos 
        
        rvest::html_text() %>%            # llamo a la función html_text() para especificar el formato 'chr' del título.
        
        tibble::as_tibble() %>%           # llamo a la función as_tibble() para transforma el vector en tabla 
        
        dplyr::rename(titulo = value)     # llamo a la función rename() para renombrar la variable 'value'
      
    }                                     # cierro la función para raspado web
    # Usamos la función para scrapear el diario El Mundo ----------------------------------------------
    (El_Mundo <- scraping_EM("https://www.elmundo.es/espana.html"))

    ## # A tibble: 65 x 1
    ##    titulo                                                                       
    ##    <chr>                                                                        
    ##  1 "Política. La anulación del impuesto de plusvalía amenaza los Presupuestos d~
    ##  2 "Política. Moncloa quiere tutelar la negociación de la reforma laboral senta~
    ##  3 "Política. La coalición de los líos: Unidas Podemos ataca por tierra, mar y ~
    ##  4 "A contrapelo. Dejadme los anuncios"                                         
    ##  5 "Terrorismo. Las víctimas del terrorismo confían en la misión de la UE sobre~
    ##  6 "Justicia. La Ley de plurilingüismo, camino por primera vez de los tribunale~
    ##  7 "Justicia. Alberto Rodríguez acusa a Batet ante el Supremo de \"modificar\" ~
    ##  8 "Congreso. El PSOE desata el malestar de sus aliados retrasando de nuevo la ~
    ##  9 "Cataluña. ERC abandona a Borràs en su intento de blindarse ante una inhabil~
    ## 10 "Política. Unidas Podemos se opone al PSOE en todos los frentes y acusa al j~
    ## # ... with 55 more rows

    # Tokenizamos los títulos de la sección 'España' del periódico El Mundo ---------------------------
    El_Mundo %>%                                          # datos en formato tabular extraídos con la función scraping_EM()
      
      tidytext::unnest_tokens(                            # función para tokenizar
        
        palabra,                                          # nombre de la columna a crear
        
        titulo) %>%                                       # columna de datos a tokenizar
      
      dplyr::count(                                       # función para contar
        
        palabra) %>%                                      # columna de datos a contar
      
      dplyr::arrange(                                     # función para ordenar columnas
        
        dplyr::desc(                                      # orden decreciente
          
          n)) %>%                                         # columna de frecuencia a ordenar en forma decreciente
      
      dplyr::filter(n > 4) %>%                            # filtramos y nos quedamos con las frecuencias mayores a 2
      
      dplyr::filter(!palabra %in% 
                      tm::stopwords("es")) %>%            # filtramos palabras comunes
      
      dplyr::filter(palabra != "españa") %>%              # filtro comodín
      
      dplyr::filter(palabra != "años") %>%                # filtro comodín
      
      ggplot2::ggplot(                                    # abrimos función para visualizar
        
        ggplot2::aes(                                     # definimos el mapa estético del gráfico
          
          y = n,                                          # definimos la entrada de datos de y
          
          x = stats::reorder(                             # definimos la entrada de datos de x
            
            palabra,                                      # con la función reorder() 
            
            + n                                           # para ordenar de mayor a menos la frecuencia de palabras
            
          )                                               # cerramos la función reorder()
          
        )                                                 # cerramos la función aes()
        
      ) +                                                 # cerramos la función ggplot()
      
      ggplot2::geom_bar(                                  # abrimos la función geom_bar()
        
        ggplot2::aes(                                     # agregamos parámetros a la función aes()
          
          fill = as_factor(n)                             # definimos los colores y tratamos la variable n como factores
          
        ),                                                # cerramos la función aes()
        
        stat = 'identity',                                # definimos que no tiene que contar, que los datos ya están agrupados 
        
        show.legend = F) +                                # establecemos que se borre la leyenda
      
      ggplot2::geom_label(                                # definimos las etiquetas de las barras
        
        aes(                                              # agregamos parámetros a la función aes()
          
          label = n                                       # definimos los valores de ene como contenido de las etiquetas
          
        ),                                                # cerramos la función aes()
        
        size = 5) +                                       # definimos el tamaño de las etiquetas
      
      ggplot2::labs(                                      # definimos las etiquetas del gráfico
            
        title = "Temas en la agenda periodística",        # definimos el título
        
        x = NULL,                                         # definimos la etiqueta de la x
        
        y = NULL                                          # definimos la etiqueta de la y
        
      ) +                                                 # cerramos la función labs()
      
      ggplot2::coord_flip() +                             # definimos que las barras estén acostadas                     
      
      ggplot2::theme_bw() +                               # definimos el tema general del gráfico
      
      ggplot2::theme(                                     # definimos parámetros para los ejes
        
        axis.text.x = 
          ggplot2::element_blank(),                       # definimos que el texto del eje x no se vea
        
        axis.text.y = 
          ggplot2::element_text(                          # definimos que el texto del eje y 
            
            size = 16                                     # definimos el tamaño del texto del eje y
            
          ),                                              # cerramos la función element_text()
        
        plot.title = 
          ggplot2::element_text(                          # definimos la estética del título
            
            size = 18,                                    # definimos el tamaño
            
            hjust = .5,                                   # definimos la alineación 
            
            face = "bold",                                # definimos el grosor de la letra
            
            color = "darkred"                             # definimos el color de la letra
            
          )                                               # cerramos la función element_text()
        
      )                                                   # cerramos la función theme()

<img src="Scraping_files/figure-markdown_strict/paquetes-1.png" width="80%" style="display: block; margin: auto;" />

Parece que durante los últimos días los temas centrales fueron la covid,
las políticas publicas en torno al coronavirus (toque de queda,
restricciones, confinamiento), disputas políticas entre el gobierno y la
oposición.

### Ejercicio 2

Gracias al Ejercicio 1 tenemos una idea general sobre cómo y para qué
hacer web scraping. En el ejercicio 1 hicimos todo en uno, desde la
extracción hasta la visualización. Ahora nos ocuparemos de ir paso a
paso. Además, haremos un raspado un poco más profundo.

Arranquemos por la función de web scraping:

    # Pueden copiar y pegar o descargarlo desde RStudio con esta línea de comando:
    # utils::download.file("https://estudiosmaritimossociales.org/ejercicio02.R", "ejercicio02.R")
    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(dplyr)
    require(rvest)
    require(tibble)
    # Creamos la función para raspar El País cuyo nombre será 'scraping_links()' ---------------------
    scraping_links <- function(pag_web, tag_link) {   # abro función para raspado web y le asigno un nombre: scraping_links.
      
      rvest::read_html(pag_web) %>%                   # llamo a la función read_html() para obtener el contenido de la página.
        
        rvest::html_elements(tag_link) %>%            # llamo a la función html_elements() y especifico las etiquetas de los títulos 
        
        rvest::html_attr("href") %>%                  # llamo a la función html_attr() para especificar el formato 'chr' del título.
        
        rvest::url_absolute(pag_web) %>%              # llamo a la función url::absolute() para completar las URLs relativas
        
        tibble::as_tibble() %>%                       # llamo a la función as_tibble() para transforma el vector en tabla
        
        dplyr::rename(link = value)                   # llamo a la función rename() para renombrar la variable 'value'
      
    }                                                 # cierro la función para raspado web
    # Usamos la función para scrapear el diario El Mundo ----------------------------------------------
    (links_EM <- scraping_links(pag_web = "https://www.elmundo.es/economia.html", tag_link = "a.ue-c-cover-content__link"))

    ## # A tibble: 65 x 1
    ##    link                                                                         
    ##    <chr>                                                                        
    ##  1 https://www.elmundo.es/economia/macroeconomia/2021/10/27/61781ec621efa0576d8~
    ##  2 https://www.elmundo.es/ciencia-y-salud/medio-ambiente/2021/10/27/61782618fdd~
    ##  3 https://www.elmundo.es/economia/empresas/2021/10/27/6177f02afdddff39678b45a6~
    ##  4 https://www.elmundo.es/economia/actualidad-economica/2021/10/27/616fe68ee4d4~
    ##  5 https://www.elmundo.es/economia/2021/10/27/6178506dfdddff22178b459f.html     
    ##  6 https://www.elmundo.es/ciencia-y-salud/medio-ambiente/2021/10/27/617819fc21e~
    ##  7 https://www.elmundo.es/economia/2021/10/26/6178322921efa0c12d8b4579.html     
    ##  8 https://www.elmundo.es/economia/ahorro-y-consumo/2021/10/26/6177f2e1fdddff91~
    ##  9 https://www.elmundo.es/economia/2021/10/26/6177df70fc6c83fa368c0240.html     
    ## 10 https://www.elmundo.es/economia/empresas/2021/10/26/6177caacfc6c8306268b45dd~
    ## # ... with 55 more rows

    # Usamos la función para scrapear el diario El País -----------------------------------------------
    (links_EP <- scraping_links(pag_web = "https://elpais.com/espana/", tag_link = "h2 a")) 

    ## # A tibble: 59 x 1
    ##    link                                                                         
    ##    <chr>                                                                        
    ##  1 https://elpais.com/espana/catalunya/2021-10-27/el-estado-mayor-del-independe~
    ##  2 https://elpais.com/espana/catalunya/2021-10-27/el-norteamericano-que-se-colo~
    ##  3 https://elpais.com/espana/2021-10-27/las-instituciones-siguen-su-marcha-entr~
    ##  4 https://elpais.com/opinion/2021-10-25/o-belarra-rectifica-o-mejor-que-se-vay~
    ##  5 https://elpais.com/opinion/2021-10-24/tanto-esperar-para-esto.html           
    ##  6 https://elpais.com/opinion/2021-10-22/espana-y-la-mala-memoria.html          
    ##  7 https://elpais.com/opinion/2021-10-14/los-dilemas-del-psoe-redefinir-el-prog~
    ##  8 https://elpais.com/opinion/2021-10-11/mas-autonomia-estrategica.html         
    ##  9 https://elpais.com/espana/2021-10-26/el-gobierno-acepta-que-trabajo-lidere-l~
    ## 10 https://elpais.com/economia/2021-10-26/la-temporalidad-y-los-convenios-los-g~
    ## # ... with 49 more rows

Cumplido el primer paso (la obtención de los links a las notas
completas), nos toca construir una función para ‘raspar’ el contenido
completo de cada nota. ¡Manos a la obra!

    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(dplyr)
    require(rvest)
    require(tibble)
    # Creamos la función para raspar El País cuyo nombre será 'scraping_links()' ---------------------
    scraping_notas <- function(pag_web, tag_fecha, tag_titulo, tag_nota) { # abro función para raspado web: scraping_notas().
      
      tibble::tibble(                               # llamo a la función tibble.
      
      fecha = rvest::html_elements(                 # declaro la variable fecha y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_fecha) %>%   # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) de la fecha. 
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' de la fecha.
      
      titulo = rvest::html_elements(                # declaro la variable titulo y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_titulo) %>%  # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) del titulo.  
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' del título.
      
      nota = rvest::html_elements(                  # declaro la variable nota y llamo a la función html_elements(). 
        
        rvest::read_html(pag_web), tag_nota) %>%    # llamo a la función html_elements() y especifico la(s) etiqueta(s) de la nota. 
        
        rvest::html_text()                          # llamo a la función html_text() para especificar el formato 'chr' del título.
      
      )                                             # cierro la función tibble().
      
    }                                               # cierro la función para raspado web.
    # Usamos la función para scrapear las notas del diario El País u otras páginas web ---------------------------
    (notas_EP  <- scraping_notas(pag_web = "https://elpais.com/espana/2021-01-16/madrid-una-semana-enterrada-en-la-nieve.html", 
                                 tag_fecha = ".a_ti",
                                 tag_titulo = "h1",
                                 tag_nota = ".a_b")) 

    ## # A tibble: 0 x 3
    ## # ... with 3 variables: fecha <chr>, titulo <chr>, nota <chr>

Resultó bien, pero ya tenemos un primer problema de normalización: el
formato de la fecha. Cuando miramos el tibble vemos que la variable
fecha es identificada y tratada como de tipo ‘chr’ (caracter). Debemos
transformarla en una variable de tipo ‘date’ (fecha). ¿Cómo lo hacemos?
Hay muchas formas. Acá vamos a hacerlo en dos pasos. Primero vamos a
quedarnos con los 11 caracteres iniciales (“dd mmm yyyy”) y luego
removemos los restantes. Finalmente, transformamos esos 11 caracteres en
un valor ‘date’ con la función `dmy()` del paquete `lubridate` de
`tidyverse`. Veamos cómo…

    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(lubridate)
    require(stringr)
    require(magrittr)
    fecha_sin_normalizar <- "16 ene 2021 - 23:30 UTC"   # creamos el objeto 'fecha_sin_normalizar'.
    (stringr::str_sub(fecha_sin_normalizar, 1, 11) %>%  # llamamos a la función str_sub() para quedarnos con los primeros 11 caracteres.   
      
      stringr::str_replace_all("ene", "jan") %>%        # llamamos a la función str_remplace_all() para cambiar la denominación de los mes.             
      stringr::str_replace_all("abr", "apr") %>% 
      stringr::str_replace_all("ago", "aug") %>% 
      stringr::str_replace_all("dic", "dec") %>% 
      
      lubridate::dmy() -> fecha_normalizada)            # finalmente llamamos a la función dmy() para transformar el string en un valor tipo 'date'.

    ## [1] "2021-01-16"

    base::class(fecha_normalizada)                      # examinamos su clase.

    ## [1] "Date"

Bien. Hemos logrado transformar la cadena de caracteres que contenía la
fecha en un valor que R reconoce y trata como ‘date’. Sin embargo,
seguimos con un problema no menor. Pudimos recuperar con al función
scraping\_notas() el contenido de una nota, pero la idea es recuperar el
contenido de un set completo de notas. Para lograrlo tendremos que hacer
uso de una nueva función de la familia tidyverse que perteneciente al
paquete `purrr`. Nos referimos a la función `pmap_dfr()`. Esta función
es una variante de la función `map()` de `purrr` que itera sobre
múltiples argumentos simultáneamente y en paralelo.

    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(dplyr)
    require(rvest)
    require(tibble)
    require(purrr)
    # Creamos la función para raspar los links a las notas cuyo nombre será 'scraping_links()' -------
    scraping_links <- function(pag_web, tag_link) {   # abro función para raspado web y le asigno un nombre: scraping_links
      
      rvest::read_html(pag_web) %>%                   # llamo a la función read_html() para obtener el contenido de la página
        
        rvest::html_elements(tag_link) %>%            # llamo a la función html_elements() y especifico las etiquetas de los títulos 
        
        rvest::html_attr("href") %>%                  # llamo a la función html_attr() para especificar el formato 'chr' del título.
        
        rvest::url_absolute(pag_web) %>%              # llamo a la función url::absolute() para completar las URLs relativas
        
        tibble::as_tibble() %>%                       # llamo a la función as_tibble() para transforma el vector en tabla
        
        dplyr::rename(link = value)                   # llamo a la función rename() para renombrar la variable 'value'
      
    }                                                 # cierro la función para raspado web
    # Usamos la función para scrapear los links a las notas de El País -------------------------------
    (links_EP  <- scraping_links(pag_web = "https://elpais.com/espana/", tag_link = "h2 a")) 

    ## # A tibble: 59 x 1
    ##    link                                                                         
    ##    <chr>                                                                        
    ##  1 https://elpais.com/espana/catalunya/2021-10-27/el-estado-mayor-del-independe~
    ##  2 https://elpais.com/espana/catalunya/2021-10-27/el-norteamericano-que-se-colo~
    ##  3 https://elpais.com/espana/2021-10-27/las-instituciones-siguen-su-marcha-entr~
    ##  4 https://elpais.com/opinion/2021-10-25/o-belarra-rectifica-o-mejor-que-se-vay~
    ##  5 https://elpais.com/opinion/2021-10-24/tanto-esperar-para-esto.html           
    ##  6 https://elpais.com/opinion/2021-10-22/espana-y-la-mala-memoria.html          
    ##  7 https://elpais.com/opinion/2021-10-14/los-dilemas-del-psoe-redefinir-el-prog~
    ##  8 https://elpais.com/opinion/2021-10-11/mas-autonomia-estrategica.html         
    ##  9 https://elpais.com/espana/2021-10-26/el-gobierno-acepta-que-trabajo-lidere-l~
    ## 10 https://elpais.com/economia/2021-10-26/la-temporalidad-y-los-convenios-los-g~
    ## # ... with 49 more rows

    # Creamos la función para raspar El País cuyo nombre será 'scraping_links()' ---------------------
    scraping_notas <- function(pag_web, tag_fecha, tag_titulo, tag_nota) { # abro función para raspado web: scraping_notas().
      
      tibble::tibble(                               # llamo a la función tibble.
      
      fecha = rvest::html_elements(                 # declaro la variable fecha y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_fecha) %>%   # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) de la fecha. 
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' de la fecha.
      
      titulo = rvest::html_elements(                # declaro la variable titulo y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_titulo) %>%  # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) del titulo.  
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' del título.
      
      nota = rvest::html_elements(                  # declaro la variable nota y llamo a la función html_elements(). 
        
        rvest::read_html(pag_web), tag_nota) %>%    # llamo a la función html_elements() y especifico la(s) etiqueta(s) de la nota. 
        
        rvest::html_text()                          # llamo a la función html_text() para especificar el formato 'chr' del título.
      
      )                                             # cierro la función tibble().
      
    }                                               # cierro la función para raspado web.
    # Seleccionamos los links que refieren a la sección que nos interesa y nos quedamos solo con 10 notas --------
    (links_EP_limpio <- links_EP %>% filter(str_detect(link, "https://elpais.com/espana/")) %>% filter(!str_detect(link,"en-clave-de-bienestar")) %>% .[1:10,])

    ## # A tibble: 10 x 1
    ##    link                                                                         
    ##    <chr>                                                                        
    ##  1 https://elpais.com/espana/catalunya/2021-10-27/el-estado-mayor-del-independe~
    ##  2 https://elpais.com/espana/catalunya/2021-10-27/el-norteamericano-que-se-colo~
    ##  3 https://elpais.com/espana/2021-10-27/las-instituciones-siguen-su-marcha-entr~
    ##  4 https://elpais.com/espana/2021-10-26/el-gobierno-acepta-que-trabajo-lidere-l~
    ##  5 https://elpais.com/espana/2021-10-26/la-calle-suaviza-la-gresca-politica-sob~
    ##  6 https://elpais.com/espana/2021-10-26/un-capitan-falsifico-la-firma-de-su-jef~
    ##  7 https://elpais.com/espana/2021-10-26/podemos-y-psoe-se-dan-otra-semana-para-~
    ##  8 https://elpais.com/espana/2021-10-26/el-gobierno-de-navarra-llega-a-un-preac~
    ##  9 https://elpais.com/espana/2021-10-26/iu-vuelve-a-pedir-al-juez-del-caso-puni~
    ## 10 https://elpais.com/espana/comunidad-valenciana/2021-10-26/cae-una-trama-fami~

    # Usamos la función pmap_dfr() para emparejar los links y la función de web scraping y creamos el objeto el_pais_esp con las 10 notas completas
    (el_pais_esp <-                     # abrimos la función print '(' y asignamos un nombre al objeto que vamos a crear.
        
        purrr::pmap_dfr(                # llamamos a la función pmap_dfr() para emparejar links y función de rascado.
          
          base::list(                   # Llamamos a la función list() para crear una lista con los múltiples argumentos de la función de rascado.
            
            links_EP_limpio$link,       # vector de links.
            
            ".a_ti",                    # etiqueta de fecha.
            
            "h1",                       # etiqueta de título.
            
            ".a_b"),                    # etiqueta de nota y cierro la función list().
          
          scraping_notas))              # función scraping_notas() sin los `()` y cierro la función pmap_dfr() y la función print `)`.

    ## # A tibble: 0 x 3
    ## # ... with 3 variables: fecha <chr>, titulo <chr>, nota <chr>

    # Usamos la función para scrapear los links a las notas de La Nación -------------------------------
    (links_LN <- scraping_links(pag_web = "https://www.lanacion.com.ar/politica", tag_link = "h2 a"))

    ## # A tibble: 30 x 1
    ##    link                                                                         
    ##    <chr>                                                                        
    ##  1 https://www.lanacion.com.ar/politica/nadie-sabe-que-hara-la-vicepresidenta-n~
    ##  2 https://www.lanacion.com.ar/politica/victoria-tolosa-paz-hablo-sobre-el-vide~
    ##  3 https://www.lanacion.com.ar/politica/alberto-fernandez-declaro-lugar-histori~
    ##  4 https://www.lanacion.com.ar/politica/que-dicen-las-nubes-de-palabras-de-albe~
    ##  5 https://www.lanacion.com.ar/politica/la-camara-de-diputados-se-apresta-a-con~
    ##  6 https://www.lanacion.com.ar/politica/maria-eugenia-vidal-le-contesto-a-marti~
    ##  7 https://www.lanacion.com.ar/politica/leandro-santoro-sobre-el-conflicto-mapu~
    ##  8 https://www.lanacion.com.ar/politica/el-oficialismo-freno-la-ficha-limpia-en~
    ##  9 https://www.lanacion.com.ar/politica/desde-el-pro-denunciaron-que-en-un-cole~
    ## 10 https://www.lanacion.com.ar/politica/en-plena-campana-el-intendente-de-la-pl~
    ## # ... with 20 more rows

    # Usamos la función para scrapear las notas de La Nación. Replicamos todo en una sola línea de código.
    (la_nacion_ar <- purrr::pmap_dfr(list(links_LN$link[1:10],".com-date.--twoxs",".com-title.--threexl",".col-12 p"), scraping_notas)) # "section.fecha","h1.titulo","#cuerpo p" scraping_notas))

    ## # A tibble: 122 x 3
    ##    fecha                 titulo                   nota                          
    ##    <chr>                 <chr>                    <chr>                         
    ##  1 27 de octubre de 2021 Nadie sabe qué hará la ~ Extrañamente, Martín Guzmán s~
    ##  2 27 de octubre de 2021 Nadie sabe qué hará la ~ El destino del país se replie~
    ##  3 27 de octubre de 2021 Nadie sabe qué hará la ~ Sin embargo, no hay peor kirc~
    ##  4 27 de octubre de 2021 Nadie sabe qué hará la ~ Un destacado dirigente empres~
    ##  5 27 de octubre de 2021 Nadie sabe qué hará la ~ Intendentes, camporistas y mo~
    ##  6 27 de octubre de 2021 Nadie sabe qué hará la ~ La aparición más novedosa fue~
    ##  7 27 de octubre de 2021 Nadie sabe qué hará la ~ La eventual derrota debe tene~
    ##  8 27 de octubre de 2021 Nadie sabe qué hará la ~ Aníbal Fernández morigeró a T~
    ##  9 27 de octubre de 2021 Nadie sabe qué hará la ~ La fijación en la venganza es~
    ## 10 27 de octubre de 2021 Nadie sabe qué hará la ~ Hay un solo funcionario que n~
    ## # ... with 112 more rows

    # Guardamos el objeto 'la_nacion_ar' como objeto .rds
    base::saveRDS(la_nacion_ar, "la_nacion_ar.rds")

Bueno, parece que finalmente realizamos todos los pasos para hacer un
web scraping completo. Pero esto no termina aquí. Seguro notaron que las
notas se trasformaron de 10 a 100, esto puede ser contraproducente en el
momento del análisis. Tenemos que normalizar la base. ¡Hagámoslo!

    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(dplyr)
    require(rvest)
    require(tibble)
    require(stringr)
    require(tidyr)
    require(lubridate)
    # Cargamos el objeto la_nacion_ar.
    la_nacion_ar <- base::readRDS("la_nacion_ar.rds")
    # Imprimimos en consola sus valores completos, las notas completas.
    la_nacion_ar$nota[1:30] # los corchetes me permiten seleccionar los valores según su número de fila

    ##  [1] "Extrañamente, Martín Guzmán se convirtió en un converso del cristinismo y Aníbal Fernández recobró, por un momento al menos, la sensatez política. Pueden ser los contradictorios destellos de un gobierno que se advierte más cerca de la ruina que de la gloria. Es un instante en el que La Cámpora se encierra aún más entre su escasa militancia, el albertismo ve llegar con ignorancia y desconfianza el día después de la derrota probable y el Presidente intuye que deberá atravesar otra “semana trágica”, como algunos funcionarios llaman a los días posteriores al desastroso 12 de septiembre pasado."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    ##  [2] "El destino del país se repliega en apenas 17 días, que son los días que faltan para las elecciones generales. El después es un arcano sin luz. “Cristina sabe lo que hará, pero no lo dice”, sostiene un funcionario de alto rango. Nadie está al tanto de lo que ella urde. ¿Puede haber desabastecimiento de alimentos? “No hasta el 14 de noviembre; veremos a partir del 15\", responde un empresario que frecuenta los despachos oficiales. Cada uno juega su propio partido, sobre todo dentro de la coalición gobernante. Parece un ejército que está por recibir la orden de retirada o que intuye que el combate está perdido."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    ##  [3] "Sin embargo, no hay peor kirchnerismo que el kirchnerismo desesperado. Roberto Feletti es la mejor expresión de la impotencia oficial. De un gobierno sin plan, pero también sin coherencia. Alberto Fernández recibió a importantes empresarios y los invitó a almorzar junto con la cúpula de La Cámpora (Máximo Kirchner y Eduardo “Wado” de Pedro). Pocos días después fue su administración la que comenzó la campaña contra los empresarios y fueron los camporistas los que restablecieron la ominosa práctica del escrache. Escracharon en las redes sociales a empresas productoras de alimentos que supuestamente no aceptaron la política de precios máximos y de control de precios. Lo hicieron señalando los nombres de las compañías y llamaron a no comprar sus productos. Esos escraches expandieron el temor entre renombrados empresarios. “Nadie sabe quién será el siguiente”, explica otro dirigente empresario. El hábito fue inaugurado por el patriarca muerto de la familia gobernante. Néstor Kirchner estrenó su presidencia con un boicot a la firma Shell porque esta no aceptaba los precios de las naftas que le indicaba el Gobierno. Usó a un dirigente piquetero, Luís D’Elía, y a un aparente dirigente empresario, Osvaldo Cornide, para concretar el boicot físico a la empresa petrolera. Fue solo la primera vez. El fascista escrache se transformó luego en un método habitual para señalar a enemigos y adversarios, a políticos y empresarios, a líderes sociales y a periodistas."
    ##  [4] "Un destacado dirigente empresario está convencido de que este es el peor momento de la relación entre ellos y un gobierno. ¿Peor que la que hubo con Guillermo Moreno? “Peor, responde, porque Moreno era patotero y maleducado, pero al final del día negociaba”. El líder fabril recuerda que también negociaron la dupla Axel Kicillof-Augusto Costa cuando estuvo al frente de la cartera económica. Miguel Braun, que fue secretario de Comercio con Macri, no dejó de negociar nunca el nivel de los precios. El actual ministro de Producción, Matías Kulfas, y la entonces secretaria de Comercio Paula Español también conversaban permanentemente con los empresarios. ¿Y Feletti? “Feletti es como Guillermo Moreno, pero sin negociación”, responde. Feletti dice que buscó un acuerdo con los empresarios para fijar precios máximos, pero nunca permitió el margen necesario para una negociación. Buscaba una rendición, no un acuerdo."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    ##  [5] "Intendentes, camporistas y movimientos sociales se dedican ahora a controlar precios. Son una especie rara de fuerzas de choque que arremeten contra los supermercados. No saben nada de economía ni de precios. La Secretaría de Comercio tiene inspectores formados para realizar esa tarea. El miedo es un herramienta más efectiva para el cristinismo. Los supermercados controlan un porcentaje importante de la oferta de alimentos, pero llega al 35 por ciento. El 65 por ciento restante está en mercados chicos o en negocios de cercanías; a estos no los controla nadie y pueden poner los precios que quieren. El control es, además, sobre el precio final que está en las góndolas de los supermercados; los proveedores de esos grandes centros comerciales pueden seguir remarcando los precios de los productos. La política de precios se convirtió en un macaneo más que en una política. En algunos productos, la retroactividad de los precios es al mes de julio, no al 1º de octubre como informó la Secretaría de Comercio. Los empresarios no saben si tener en cuenta el mes de julio o el de octubre. Entre uno y otro mes, hubo importantes incrementos en los índices inflacionarios."                                                                                                                                                                                                                                                                                                          
    ##  [6] "La aparición más novedosa fue la del ministro de Economía, Guzmán, quien hizo suya la política de Feletti. “No hay dos políticas distintas, sino una sola”, dijo, y encima suscribió la versión conspiranoica del camporismo: “En la Argentina hay una colisión estructural de intereses”. Se refería a los intereses del capitalismo y los “del pueblo”. El ministro que vino a poner cierta moderación en la conducción económica y que prometió hacer lo que estudió en la cátedra (renegociar las deudas soberanas de los países), termina ahora convertido al fanatismo cristinista. Empujado por la decisión de conservar el cargo, no bregó por la moderación de la coalición que lo ungió. Hizo al revés: se radicalizó él mismo junto con el ala más radicalizada del Gobierno. Guzmán fue el descubrimiento de Alberto Fernández; será también su decepción."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    ##  [7] "La eventual derrota debe tener un culpable: es la oposición. Victoria Tolosa Paz dejó de hablar –en buena hora– del sexo de los peronistas, pero se dedica a denunciar un “golpe blando” que, según ella, programan los opositores para antes del 14 de noviembre. Golpe blando es una definición relativamente nueva que refiere a procesos de desestabilización de los gobiernos con métodos no violentos. La democracia argentina soportó crisis como las hiperinflaciones de fines de los 80 y principios de los 90 o el gran colapso de 2001/2002, que hasta requirió el reemplazo del expresidente Fernando de la Rúa, que renunció provocando la crisis política e institucional más grave desde 1983. Nunca estuvo en duda el sistema democrático ni el respeto a los mecanismos previstos por la Constitución. ¿Cómo calificaríamos entonces las marchas kirchneristas durante el gobierno de Macri, que portaban la maqueta de un helicóptero en alusión a la forma en que De la Rúa se fue de la Casa de Gobierno después de renunciar? Era un clamor para que Macri renunciara y se fuera en un helicóptero. ¿Eso era un golpe blando o un golpe duro? El golpe más claro y certero contra Alberto Fernández lo dio la propia Cristina Kirchner, vicepresidenta y jefa política de la coalición gobernante, cuando escribió la carta posterior a la derrota del 12 de septiembre. Con esas pocas líneas arrebatadas le cambió el gabinete al Presidente. Golpe duro, sin duda."                                    
    ##  [8] "Aníbal Fernández morigeró a Tolosa Paz y volvió por un instante a ser el traqueteado político que fue. “La política es así. No vivimos entre algodones”, descalificó a la candidata bonaerense. La política es así, en efecto. Cargada de ambiciones y especialmente implacable en tiempos electorales. Esa realidad la conocían bien Raúl Alfonsín, Carlos Menem, Eduardo Duhalde y el propio Macri. Nunca se los escuchó hablar de conspiraciones ni de persecuciones. No carecieron de enemigos ni de conjuras ni de intrigas, pero entendieron que esas cosas forman parte de la vida que eligieron. Solo con el kirchnerismo se inauguró un período de constantes denuncias de supuestos golpismos o de actitudes destituyentes. El fracaso propio debe tener un nombre ajeno."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    ##  [9] "La fijación en la venganza es la única obsesión permanente (y coherente) del cristinismo que gobierna. Macri deberá concurrir mañana a los tribunales de Dolores para responder a una indagatoria del juez federal Martín Bava. Lo citó en un expediente por el supuesto seguimiento a familiares de las víctimas del submarino ARA San Juan. Bava es un juez en los Civil de Azul que subroga un juzgado penal en Dolores; hay pocos jueces con peores antecedentes académicos que Bava. En esa causa, ningún testigo nombró a Macri ni ninguna prueba lo señala al expresidente. Su nombre está solo escrito en las primeras líneas de la inicial denuncia. El juez entendió, a pesar de todo, que si hubo seguimiento Macri debió saberlo o debió autorizarlo. Una inferencia que contradice cada línea del Código Penal argentino. Macri pidió el apartamiento de Bava y este pasó el reclamo, como corresponde, a la Cámara Federal de Mar del Plata, su superior, para que lo acepte o lo rechace. En tales casos, los jueces suelen detener su instrucción hasta que la Cámara se expide. Bava es la excepción: mandó el pedido a la Cámara, pero él sigue actuando como juez. Urgencias electorales."                                                                                                                                                                                                                                                                                                                  
    ## [10] "Hay un solo funcionario que no piensa en derrotas ni en victorias, sino en la venganza: es Carlos Zannini, procurador del Tesoro, jefe de los abogados del Estado. Acaba de pedir que en el marco del largo proceso judicial por el caso del Correo, propiedad de la familia Macri desde los años 90, se declare también la quiebra de Socma, la casa matriz de todas las empresas de la familia del expresidente. El caso del Correo está en la Corte Suprema para que esta decida si se resolverá en los tribunales federales o en los de la Capital. La Corte debería decidir cuanto antes sobre el tema para no permitir que exista el revanchismo en la política argentina y, sobre todo, que se use a la justicia para esos fines innobles."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    ## [11] "Exfuncionarios de Macri recibieron la propuesta de empinados kirchneristas para que lo incriminen al expresidente a cambio de liberarlos de cualquier desventura judicial. Una exfuncionaria les contestó con una frase corta y definitiva: “Hay un problema: yo tendría que nacer de nuevo para hacer eso”. Hay también una paradoja: Macri es al parecer el autor del golpe blando contra el kirchnerismo, pero es, al mismo tiempo, quien caminará mañana por el corredor destinado a las revanchas del kirchnerismo."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    ## [12] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    ## [13] "La candidata del Frente de Todos Victoria Tolosa Paz se refirió anoche al video en el que aparece haciendo compras en un shopping, acompañada de su marido Enrique “Pepe” Albistur. “No tengo por qué someterme al escarnio público”, dijo la candidata del oficialismo."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    ## [14] "En declaraciones a Canal Nueve Tolosa Paz relativizó la polémica y las críticas que recibió sobre las imágenes. Cuando se la consultó sobre el video, en donde se ve a la pareja con una importante cantidad de bolsas, expresó: “Voy a seguir haciendo mi vida como todos los días”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    ## [15] "Además, la titular del Consejo del Hambre aclaró que el video es de hace un mes atrás. “Fue antes de las elecciones. Pasé por un shopping y compré regalos para las hijas de mi marido y mis nietos, tengo todo el derecho del mundo de comprar lo que quiero”, esgrimió Tolosa Paz."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    ## [16] "El “golpe blando” lo está dando Derrota Tolosa Paz en el shopping <U+0001F449> pic.twitter.com/Hkx6zGwgnu"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    ## [17] "“Quiero seguir siendo quien fui, administro mi hogar, hago las compras y mandados. Si alguien elige viralizarlo voy a seguir caminando las calles de la Argentina”, expresó la candidata del Frente de Todos."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    ## [18] "En esta línea, Tolosa Paz apuntó contra la candidata de Juntos por el Cambio María Eugenia Vidal y la controversia que se generó alrededor de la compra de un departamento. “Yo puedo dar cuenta de mi patrimonio”, dijo, y acusó a la exgobernadora de no poder explicar la compra del inmueble. “Hay inconsistencia en su declaración”, agregó."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    ## [19] "La aspirante a legisladora acusó esta semana a Juntos por el Cambio de estar preparando un “golpe blando” antes de las elecciones legislativas del 14 de noviembre, y en medio de sus declaraciones, apareció el video del shopping que fue difundido por usuarios en redes sociales."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    ## [20] "Frente a estas imágenes, Tolosa Paz responsabilizó por la difusión del video “al ejército de trolls de Marquitos Peña” por el exjefe de Gabinete del entonces presidente Mauricio Macri. E involucró al jefe de Gobierno de la Ciudad de Buenos Aires, Horario Rodríguez Larreta, y al candidato a diputado por Juntos por el Cambio Diego Santilli."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    ## [21] "La candidata a diputada del oficialismo fue consultada sobre la declaración sobre que la oposición se encontraba llevando adelante un “golpe blando”. Lo había dicho en una entrevista con AM 750. Sobre esto, Tolosa Paz reclamó: “Nos quieren dar cátedra en lugar de tener un poco de humildad, un poco de responsabilidad”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    ## [22] "En esta línea, reafirmó sus dichos al considerar que la oposición lleva adelante “intentos de desestabilizar económicamente, intentos de devaluar la moneda, intentos constantes y sonantes”. Y concluyó: “En el mundo se llaman golpes blandos, dañar al gobierno de turno en busca de construir un rédito”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    ## [23] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    ## [24] "El presidente Alberto Fernández declaró por decreto “Lugar Histórico Nacional” la casa natal de Diego Maradona, ubicada en Azamor 523 en Villa Fiorito, partido de Lomas de Zamora. La medida se publicó este miércoles en el Boletín Oficial."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    ## [25] "La decisión tiene lugar a solicitud de la Comisión Nacional de Monumentos, de Lugares, y de Bienes Históricos, un organismo desconcentrado del Ministerio de Cultura. El ente deberá ahora ejercer la dirección de la vivienda y “practicar las inscripciones correspondientes en los Registros Catastrales y de la Propiedad Inmueble”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    ## [26] "En los considerandos de la norma se señala que la influencia de Diego Maradona “trasciende sus méritos deportivos y lo constituye a la luz de su reciente fallecimiento como uno de los símbolos más reconocibles de nuestra identidad”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    ## [27] "El decreto firmado por Alberto Fernández señala que la casa presenta “un patio de tierra con puerta alambrada en su ingreso, un comedor y dos habitaciones”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    ## [28] "Y cita que a la vuelta de la casa se ubicaban siete “potreros”, en los que Maradona “comenzó a forjarse como futbolista durante su infancia”. Y detalla que una de esas “canchitas” pertenecía al equipo barrial “Estrella Roja”, “entrenado por “Don Diego” Maradona, que habitualmente incluía a su hijo Diego en la formación”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    ## [29] "La norma agrega que la vivienda de Villa Fiorito representó para Maradona, “durante toda su vida, la fidelidad a sus orígenes y los profundos lazos que lo unían con su familia”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    ## [30] "En ese sentido, se precisa que en ese sitio se instalaron “sus padres, Diego Maradona y Dalma Salvadora Franco, más conocidos como “Don Diego” y “Doña Tota”, oriundos de la Ciudad de Esquina, provincia de Corrientes, con sus hijas Ana Estela y Rita Mabel, hermanas mayores” del futbolista."

    # Detectamos que hay algunas filas que son recurrente y debemos borrar:
       # "Celdas vacías"
    # Con el uso del paquete stringr vamos a remover estos fragmentos de información no útil.
    (la_nacion_ar_limpia <- la_nacion_ar %>%                                  # creamos un nuevo objeto clase tibble.
        
        dplyr::mutate(nota = stringr::str_trim(nota)) %>%                     # con las funciones mutate() y str_trim() quitamos los espacios en blanco sobrantes.
        
        dplyr::filter(nota != ""))                                            # con la función filter() descartamos las celdas vacías.

    ## # A tibble: 112 x 3
    ##    fecha                 titulo                   nota                          
    ##    <chr>                 <chr>                    <chr>                         
    ##  1 27 de octubre de 2021 Nadie sabe qué hará la ~ Extrañamente, Martín Guzmán s~
    ##  2 27 de octubre de 2021 Nadie sabe qué hará la ~ El destino del país se replie~
    ##  3 27 de octubre de 2021 Nadie sabe qué hará la ~ Sin embargo, no hay peor kirc~
    ##  4 27 de octubre de 2021 Nadie sabe qué hará la ~ Un destacado dirigente empres~
    ##  5 27 de octubre de 2021 Nadie sabe qué hará la ~ Intendentes, camporistas y mo~
    ##  6 27 de octubre de 2021 Nadie sabe qué hará la ~ La aparición más novedosa fue~
    ##  7 27 de octubre de 2021 Nadie sabe qué hará la ~ La eventual derrota debe tene~
    ##  8 27 de octubre de 2021 Nadie sabe qué hará la ~ Aníbal Fernández morigeró a T~
    ##  9 27 de octubre de 2021 Nadie sabe qué hará la ~ La fijación en la venganza es~
    ## 10 27 de octubre de 2021 Nadie sabe qué hará la ~ Hay un solo funcionario que n~
    ## # ... with 102 more rows

    # Ahora colapsaremos los párrafos de cada nota en una sola celda, de esta forma volveremos a un tibble de 10 filas (observaciones), una por nota.
    (la_nacion_ar_limpia_norm <- la_nacion_ar_limpia %>%                                # creamos un nuevo objeto clase tibble.
        
      dplyr::group_by(fecha, titulo) %>%                                                # con la función group_by() agrupamos por fecha y título.
        
      dplyr::summarise(nota_limpia = base::paste(nota, collapse = " ||| ")) %>%         # con las funciones summarise() y paste() colapsamos los párrafos.
      
      dplyr::select(fecha, titulo, nota_limpia) %>%                                     # con la función select() seleccionamos las variables. 
      
      dplyr::mutate(fecha = lubridate::dmy(fecha)))                                     # con las funciones mutate() y dmy() le damos formato date al string de fechas.

    ## # A tibble: 10 x 3
    ## # Groups:   fecha [2]
    ##    fecha      titulo                          nota_limpia                       
    ##    <date>     <chr>                           <chr>                             
    ##  1 2021-10-26 Desde el PRO denunciaron que e~ "En medio de la situación de viol~
    ##  2 2021-10-26 El Frente de Todos no quiso vo~ "La coalición oficialista Frente ~
    ##  3 2021-10-26 En plena campaña, el intendent~ "La República de los Niños de La ~
    ##  4 2021-10-26 Leandro Santoro, sobre el conf~ "El candidato a diputado nacional~
    ##  5 2021-10-26 María Eugenia Vidal le contest~ "María Eugenia Vidal cruzó este m~
    ##  6 2021-10-27 Alberto Fernández declaró Luga~ "El presidente Alberto Fernández ~
    ##  7 2021-10-27 La Cámara de Diputados convirt~ "Tras varias horas de intenso deb~
    ##  8 2021-10-27 Nadie sabe qué hará la vicepre~ "Extrañamente, Martín Guzmán se c~
    ##  9 2021-10-27 Qué dicen las nubes de palabra~ "Según un reciente estudio de opi~
    ## 10 2021-10-27 Victoria Tolosa Paz habló sobr~ "La candidata del Frente de Todos~

    # Imprimimos en consola sus valores completos, las notas completas.
    la_nacion_ar_limpia_norm$nota_limpia[1:10] # los corchetes me permiten seleccionar los valores según su número de fila

    ##  [1] "En medio de la situación de violencia en la Patagonia, una denuncia de un concejal del partido PRO abrió una nueva polémica. El edil Marcelo Bermúdez denunció que alumnos de una escuela juraron en un mismo acto lealtad a la bandera argentina y también a la insignia utilizada por la comunidad mapuche. ||| Bermúdez comunicó a través de sus redes sociales que le envió una nota de protesta a la directora del establecimiento y demandó medidas a las autoridades educativas. ||| “Recientemente en la Escuela 182 de Neuquén se realizó el acto de Promesa a la Bandera por parte de los alumnos del nivel Primario. Pero en el mismo acto prometieron consignas a la bandera nacional y a la bandera mapuche. Le envié una nota de queja a la Directora”, apuntó el edil. ||| El dirigente opositor acompañó la publicación junto a una fotografía que representa la preparación del acto en el que se ven sillas vacías, un cartel con la frase “Sí, prometo”, y las banderas argentinas y de la comunidad mapuche. ||| Bermúdez sostuvo que cursará en los próximos días un pedido de informes a la ministra de Educación de la provincia, Cristina Storioni, “para que tome conocimiento de esta irregular situación”. ||| Recientemente en la Escuela 182 de Neuquen, se realizó el acto de Promesa a la Bandera por parte de los alumnos del nivel Primario. Pero en el mismo acto prometieron consignas a la Bandera Nacional y a la Bandera Mapuche. Le envié una nota de queja a la Directora. Abro Hilo pic.twitter.com/hQRgbHXd1A ||| La publicación generó discusión en Twitter. “No son banderas equivalentes. Una representa un Estado Nación y, otra, un Pueblo. La diferencia es notoria”, argumentó al responderle a un usuario que manifestó su disconformidad. ||| En ese sentido amplió: “Los mapuches tienen el derecho de pensar su bandera como quieran. Pero la Nación Argentina en ejercicio de su soberanía no reconoce a otra Nación en su territorio. Es una cuestión de Constitución, no de autopercepción”. ||| Por otro lado, cuestionó a los usuarios que le marcaban el respeto por los derechos de las comunidades originarias preexistentes. “Antes del 9/7/1816 fecha de nuestra independencia no había mapuches en este territorio. Habitaban solo al Oeste de la Cordillera. Llegaron después. Por eso no son preexistentes”, expresó. ||| No se trata de la primera polémica respecto de la bandera mapuche. Días atrás en ocasión de un acto encabezado por el presidente Alberto Fernández en Comodoro Rivadavia también flameó la insignia. Y hubo controversias en las redes."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    ##  [2] "La coalición oficialista Frente de Todos frustró hoy el tratamiento de un proyecto de “ficha limpia” en la Cámara de Diputados, que impulsó el interbloque de Juntos por el Cambio con el objetivo de “garantizar la transparencia electoral” y bloquear el acceso a cargos electivos de candidatos con condenas por hechos de corrupción. ||| La bancada oficialista, junto a aliados de bloques menores, impidió que se votara favorablemente un “apartamiento de reglamento” solicitado por la diputada Silvia Lospennato (Pro) para tratar sobre tablas el proyecto de “ficha limpia”. La votación fue ajustada: 117 legisladores votaron en contra y otros 116 a favor. Pero en rigor, el reglamento de la Cámara baja establece que para que una iniciativa sea tratada directamente en el recinto –sin tener dictamen de comisión- debe obtener al menos el apoyo de tres cuartas partes de los legisladores presentes en la sesión. ||| Les dejo mi intervención y les pido  que se sumen a la iniciativa ciudadana de @FichaLimpia <U+0001F449><U+0001F3FC> https://t.co/27wzGY1kFF pic.twitter.com/dzHQrj3kFw ||| “Defienden votar con un sistema que les permite hacer trampa y elegir como legisladores a quienes no son dignos del Parlamento”, acusó al oficialismo el diputado radical santacruceño Álvaro de Lamadrid. A su vez, Waldo Wolff dijo: “Se votó ficha limpia para que no puedan ser candidatos aquellos que tengan condena por delitos de corrupción, pero hay que consensuar y coso”, ironizó. ||| En la votación, Juntos por el Cambio se inclinó a favor del apartamiento de reglamento –para impulsar el proyecto de Lospennato- y el Frente de Todos lo rechazó. Sólo dos legisladores se abstuvieron, ambos del Frente de Izquierda, entre ellos, el postulante bonaerense Nicolás del Caño. ||| El resultado de la votación por #FichaLimpia, requería mayoría especial, pero nos faltó un voto para ganar la votación. Eso nos jugamos en noviembre! pic.twitter.com/4k3TAPMcdy ||| La propuesta de Lospennato implicaba una modificación a la ley orgánica de los partidos políticos para “prohibir ser candidatos a las personas condenadas por delitos dolosos contra el Estado”. La diputada macrista porteña dijo en el recinto, mientras se sesionaba sin quorum, que impulsa esta iniciativa sin suerte desde 2015 y que no pierde las “esperanzas” de que en alguna oportunidad reciba un dictamen favorable en la estratégica Comisión de Asuntos Constitucionales. ||| Desde el Interbloque Federal, la diputada bonaerense Graciela Camaño reprochó que el proyecto “debió ser aprobado en la gestión anterior”, en referencia al gobierno de Cambiemos, cuando tampoco se consiguió apoyo para la iniciativa, pese a que la coalición que integra era más numerosa que la del por entonces Frente para la Victoria (luego Frente de Todos). ||| Sin embargo, afirmó Camaño, el proyecto fue bloqueado en el Senado “por quien ustedes llevaron como candidato a vicepresidente”, dijo la legisladora, en referencia a Miguel Ángel Pichetto, quien por entonces encabezaba el bloque del PJ en la Cámara alta. ||| El de Lospennato no fue el único proyecto que Juntos por el Cambio quiso incorporar sin éxito al temario de la sesión especial de la Cámara baja: idéntico destino sufrió una iniciativa para que se convoque a comité de crisis como dispone la ley de seguridad interior para atender el conflicto mapuche en Río Negro, un juicio político contra Aníbal Fernández y una citación al jefe de Gabinete, Juan Manzur. También un proyecto del radical Facundo Suárez Lastra para que se debata sobre el posicionamiento internacional del país respecto a la violación de los derechos humanos en América Latina, como sucede en Venezuela y Nicaragua."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    ##  [3] "La República de los Niños de La Plata está en disputa entre el gobernador de la provincia de Buenos Aires, Axel Kicillof, y el intendente de esa ciudad, Julio Garro. En plena campaña electoral, el mandatario bonaerense cuestionó la gestión del dirigente platense y lanzó: “Tenemos que tener una capital de la que estemos orgullosos”. ||| El enfrentamiento generó un abrazo simbólico al parque educativo, donde vecinos de La Plata se manifestaron para evitar que la gestión pase a la gobernación de la Provincia. En la protesta, se presentaron cientos de personas con la consigna “con la Repu, no”. De la manifestación participaron dirigentes de Juntos por el Cambio cercanos al jefe comunal platense. ||| Además de cuestionar a la exgobernadora bonaerense María Eugenia Vidal, Kicillof apuntó contra Garro por el estado del espacio público en La Plata. “No quiero polemizar con el intendente”, se anticipó. Sin embargo, lo criticó con dureza: “Pero las calles, las veredas... La ciudad está abandonada”. ||| En ese contexto, Kicillof “le pidió” a Garro “por la República de los Niños y el Anfiteatro del Lago”. Así, planteó: “Eso es muy importante, porque estamos haciendo inversiones muy grandes. Quiero que la República de los Niños vuelva a ser de la Provincia. Si no, que Garro haga lo que tiene que hacer. Si no, hacer convenios”. ||| La respuesta de Garro no tardó en llegar y aseguró que demandará a la Provincia para saldar cuentas pendientes. “La próxima semana iniciaré una demanda judicial para que la provincia de Buenos Aires salde la deuda de $1.133.000.777 de capitalidad (más intereses) que tiene con todos los platenses”, anunció. ||| “Como Intendente me siento anfitrión y por eso me animo a contarles un poco de nuestra historia. Hace pocos años sufrimos la peor tragedia colectiva como consecuencia de la improvisación y la falta de inversión”, escribió en Twitter, el pasado viernes. ||| “El Teatro del Lago y la República de los Niños son patrimonio de los platenses. En épocas de ‘gobiernos populares’ en la ‘Repu’ los punteros cobraban entradas. Estaba en ruinas, pero con el esfuerzo de los vecinos la recuperamos: la mejoramos y le sumamos nuevas atracciones y servicios”, denunció el intendente de Juntos por el Cambio. ||| Hoy la realidad es otra. Por eso, nos podemos encargar de revertir el atraso en infraestructura de más de 25 años. Ya hicimos 1500 calles, pusimos 1250 cámaras y vamos a seguir. ||| Y continuó: “Hoy la realidad es otra. Por eso, nos podemos encargar de revertir el atraso en infraestructura de más de 25 años. Ya hicimos 1500 calles, pusimos 1250 cámaras y vamos a seguir”. ||| Este martes, el primer candidato a diputado de Juntos por La Plata y actual funcionario de Garro, Fabián Perechodnik, participó de abrazo al parque y, desde las redes sociales, comunicó: “Kicillof les quiere quitar la República de los Niños a los platenses porque sabe que es lo único que va poder gobernar después del 14 de noviembre. Juntos vamos a defenderla”. ||| <U+0001F449> @Kicillofok le quiere quitar la República de los Niños a los platenses porque sabe que es lo único que va poder gobernar después del 14 de Noviembre. Juntos vamos a defenderla <U+270B>#ConLaRepuNO #AbrazoalaRepu #basta #bastadeabusodepoder #republicadelosniños pic.twitter.com/g06YvsVmyx"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    ##  [4] "El candidato a diputado nacional Leandro Santoro fue consultado esta noche sobre el conflicto en el sur del país y manifestó que aún es algo localizado en la provincia de Río Negro. “Mi percepción desde la ciudad de Buenos Aires es que no hay terrorismo en el sur”, dijo en diálogo con TN, aunque se mostró algo reacio a opinar sobre el tema. ||| Al ser consultado sobre el entredicho entre la gobernadora Arabela Carreras, que solicitó al gobierno nacional el envío de fuerzas federales, y el ministro de Seguridad, Aníbal Fernández, Santoro aclaró: “Los políticos no pueden hablar de todo porque para eso necesitan tener información”. ||| Luego, en diálogo con TN, el candidato compartió su mirada sobre el conflicto. “Que existan grupos violentos para presionar eso ya lo sabemos, ahora decir que hay terrorismo... Una cosa es la preocupación y otra que le pongan ese rótulo”, criticó Santoro en una clara alusión a referentes de la oposición, pero también del oficialismo, como Sergio Berni. Y luego agregó: “Tengo la sensación de que ese conflicto responde a conflictos locales que debería resolver el gobierno provincial”. ||| Santoro manifestó que la ocupación de tierras y la utilización de la violencia le parecen “un desastre”, pero llamó a poner las cosas “en su justo medio”. No obstante, se mostró preocupado por los actos de violencia que ejercen estos grupos. “Yo no quiero vivir en una Argentina así, no va por ahí el modelo de país que yo quiero ni el que quiero para mis hijos”. ||| También reconoció que los entredichos entre Aníbal Fernández y su par bonaerense Sergio Berni -quien aseguró que los mapuches violentos son terroristas- generan problemas extras al gobierno nacional. “Si las internas o los ruidos pudieran no existir ayudaría a que todo funcionara mejor”, dijo. ||| “Estoy seguro de que cuando sean las elecciones no nos vamos a acordar de los mapuches. Mañana va a ser otro tema, no creo que sea culpa de un cerebro maligno sino que es un sistema que entre todos tendríamos que tratar de desarmar para que no sea solamente la chicana y la cosa de corto plazo lo que construye la Argentina”, dijo en otro momento."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    ##  [5] "María Eugenia Vidal cruzó este martes al ministro de Economía, Martín Guzmán, luego de que le achacara tener una “postura anti-Argentina” y lo calificó como “irresponsable”. La primera candidata a diputada de Juntos por el Cambio destacó, en ese sentido, el respaldo que recibió la oposición en las PASO del 12 de septiembre. ||| “La primera respuesta se la dieron los 9 millones de argentinos que nos votaron hace poco tiempo”, afirmó Vidal en declaraciones a A24. La exgobernadora bonaerense consideró desafortunado el término utilizado por el ministro de Economía. ||| “La palabra anti-Argentina y la palabra golpe son palabras de la dictadura, las fuerzas democráticas no usamos estas palabras”, remarcó y agregó: “Es irresponsable. Los argentinos tenemos un acuerdo con la democracia”. Y agregó: “Me parece irresponsable utilizarlo en campaña y de manera tribunera”. ||| En ese sentido, la candidata señaló que Guzmán, que “se dedica a atacar en forma intolerante a la oposición”, no da respuestas sobre los problemas graves” del país como el “50% de inflación”, “el 40% de pobreza” y mencionó que “10 millones de argentinos entre los que trabajan en negro y los que buscan trabajo”. Y recalcó: “Y no hay plan hace dos años”. ||| Vidal criticó el argumento oficialista sobre el tamaño de la deuda tomado por la administración de Cambiemos y las consecuencias que eso dejó para la economía argentina. Para la candidata opositora, los volúmenes de compromisos en moneda extranjero no son tan disímiles y aludió a “problemas estructurales”. ||| “Cristina Fernández de Kirchner tomó 42.000 millones de dólares de deuda en su último mandato y gastó 30.000 millones de dólares de reservas. Eso da 72.000 millones de dólares” sostuvo y agregó: “Mauricio Macri tomó 70.000 millones de dólares”. A su vez, indicó: “Alberto Fernández lleva en lo que va de su mandato más de 30.000 millones de dólares.”. ||| De esta forma, Vidal se preguntó: ¿El problema es Macri o es el déficit?  ¿Vamos a encarar los problemas en serio o vamos a ver a quién le echamos la culpa?. ||| Por su parte, volvió a referirse a Guzmán y ratificó sus cuestionamientos a las críticas al congelamiento de precios. “Creo que el ministro se molestó porque dije que los congelamientos de precios no servían. Pero no porque lo diga María Eugenia Vidal, sino porque los hechos demuestran que desde 1970 hasta acá se hicieron en diez oportunidades en distintos gobiernos, de distinto signo político, y no funcionaron”, aseveró. ||| En los últimos días, Martín Guzmán empezó a levantar el tono crítico de sus afirmaciones contra la oposición. “De un lado tenemos a Juntos por el Cambio que formó un acuerdo con el establishment en contra de los intereses del pueblo. Lo que hacen es tener una postura anti-Argentina”, afirmó el ministro de Economía en una reciente entrevista en C5N. ||| Acto seguido, el funcionario apuntó de lleno contra la exgobernadora bonaerense. “La posición que tienen dirigentes clave de Juntos por el Cambio, como [María Eugenia] Vidal, es antisoberanía y anti-Argentina. Nuestro contrato es con el pueblo argentino”. Y remarcó: “Cuando a la derecha le tiramos la justa, automáticamente saca sus perros a ladrar. Si no no podrían ganar ninguna elección”. ||| Vidal, que ya había insinuado sus aspiraciones presidenciales, reiteró que puede ser candidata a ocupar la jefatura de Estado en 2023 o en otro lugar que haga falta. “Yo ya dije que voy a estar en el lugar que tenga que estar para que Juntos por el Cambio gane la elección”, afirmó la exgobernadora. ||| Al ser consultada sobre si permanecerá los cuatro años en la Cámara de Diputados, Vidal esquivó una definición. “Lo dije a lo largo de toda la campaña.Y eso supone que pueda seguir dos años más de diputada, que vaya de concejal de La Matanza, o que sea candidata a presidenta”, manifestó. ||| Y amplió: “Lo que haga falta, lo voy a hacer porque creo este no es el camino para la Argentina. El modelo que ofrece el kirchnerismo no es el que quiero para mi país”. Y apuntó: “Juntos por el Cambio es la única fuerza opositora que le puede ganar al kirchnerismo”."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    ##  [6] "El presidente Alberto Fernández declaró por decreto “Lugar Histórico Nacional” la casa natal de Diego Maradona, ubicada en Azamor 523 en Villa Fiorito, partido de Lomas de Zamora. La medida se publicó este miércoles en el Boletín Oficial. ||| La decisión tiene lugar a solicitud de la Comisión Nacional de Monumentos, de Lugares, y de Bienes Históricos, un organismo desconcentrado del Ministerio de Cultura. El ente deberá ahora ejercer la dirección de la vivienda y “practicar las inscripciones correspondientes en los Registros Catastrales y de la Propiedad Inmueble”. ||| En los considerandos de la norma se señala que la influencia de Diego Maradona “trasciende sus méritos deportivos y lo constituye a la luz de su reciente fallecimiento como uno de los símbolos más reconocibles de nuestra identidad”. ||| El decreto firmado por Alberto Fernández señala que la casa presenta “un patio de tierra con puerta alambrada en su ingreso, un comedor y dos habitaciones”. ||| Y cita que a la vuelta de la casa se ubicaban siete “potreros”, en los que Maradona “comenzó a forjarse como futbolista durante su infancia”. Y detalla que una de esas “canchitas” pertenecía al equipo barrial “Estrella Roja”, “entrenado por “Don Diego” Maradona, que habitualmente incluía a su hijo Diego en la formación”. ||| La norma agrega que la vivienda de Villa Fiorito representó para Maradona, “durante toda su vida, la fidelidad a sus orígenes y los profundos lazos que lo unían con su familia”. ||| En ese sentido, se precisa que en ese sitio se instalaron “sus padres, Diego Maradona y Dalma Salvadora Franco, más conocidos como “Don Diego” y “Doña Tota”, oriundos de la Ciudad de Esquina, provincia de Corrientes, con sus hijas Ana Estela y Rita Mabel, hermanas mayores” del futbolista."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    ##  [7] "Tras varias horas de intenso debate, la Cámara de Diputados convirtió esta noche en ley el proyecto que obliga a los productores de alimentos envasados a incluir un esquema de etiquetado frontal con octógonos negros que adviertan sobre los excesos en materia de azúcares, sodio, calorías y de grasas saturadas y totales. ||| El proyecto, que obtuvo media sanción del Senado hace un año, se aprobó con 200 votos positivos frente a 22 negativos y 16 abstenciones. Si bien la mayoría de los legisladores apoyó en términos generales la iniciativa, varios plantearon objeciones y se abstuvieron de votar algunos de sus artículos. Otro grupo de diputados –en su mayoría de Pro– rechazaron la iniciativa por considerar que el esquema de octógonos previsto en la iniciativa resulta “hostil y estigmatizante” y que, en lugar de propender hacia una educación en materia alimentaria, impone censuras y prohibiciones. ||| El oficialismo, en la voz de la presidenta de la Comisión de Legislación General, Cecilia Moreau, defendió la iniciativa y retrucó los cuestionamientos a la ley, al enfatizar que no prohibirá la comercialización de ningún producto. ||| “Con esta ley vamos a subir un escalón en la prevención de la salud y en garantizar los derechos de todos los argentinos. El octógono negro de advertencia es la forma más eficaz de comunicar la presencia o ausencia en nutrientes críticos en los alimentos. Hoy estamos rodeados de productos ultraprocesados con exceso en grasas, sal y azúcares. Las etiquetas son engañosas y a veces ilegibles; los consumidores tienen el derecho a saber qué es lo que está consumiendo e ingiriendo”, enfatizó la legisladora, quien advirtió que el 66% de la población en nuestro país tiene sobrepeso y el 32% padece obesidad, mientras que el 42% sufre presión alta. ||| En la misma línea, la diputada oficialista Liliana Schwindt enfatizó que esta ley es de salud pública, pues apunta a prevenir enfermedades como la diabetes, la hipertensión y la obesidad. “Constituyen una pandemia silenciosa”, advirtió. ||| En la vereda contraria, los diputados Carmen Polledo y Alejandro García, de Pro, anticiparon fuertes críticas al proyecto. “Comparto la idea general del proyecto de promover una alimentación saludable de los productos que consume la población –sostuvo Polledo–. Su objetivo es poner en cada paquete un octógono negro por cada nutriente crítico que excede el límite sugerido y prohibir que se informen sobre las cualidades positivas que este contenga. Hay una posición de fanatismo de imponer de que hay una sola forma posible de etiquetado, cuando no la hay”. ||| “Debemos pensar en un sistema de etiquetado integral y completo. El cambio se construye educando y no se impone por la fuerza, nadie está autorizado para modificar ni dirigir los hábitos de los demás”, enfatizó. ||| El diputado y presidente de la Comisión de Acción Social y Salud, el oficialista Pablo Yedlin, admitió que, por su condición de tucumano y oriundo de una provincia azucarera, le resultó difícil pronunciarse sobre esta ley. “El azúcar es un elemento que puede derivar en el sobrepeso, pero no es un veneno, en absoluto. Muchos edulcorantes tendrán que explicar cuán saludables son. Igualmente voy a votar a favor, pero no debe creerse que con los octógonos negros se va solucionar el sobrepeso y la obesidad. Eso no fue demostrado en Chile y México, donde rige el etiquetado frontal”, sostuvo. ||| “En general, es un proyecto virtuoso y pudo haber sido mejorado”, sostuvo Yedlin, quien propuso que el nuevo rotulado solo sea incorporado en los alimentos procesados y ultraprocesados y que queden eximidos los productos dietarios y los destinados a la lactancia. ||| La bancada de Juntos por el Cambio se mostró dividida. Mientras el grueso del radicalismo y de la Coalición Cívica apoyaban la iniciativa, la mayoría de los diputados de Pro se inclinaba por votar en contra. ||| “Es una iniciativa que busca dar paso a una transformación en los hábitos alimentarios para hacerlos más saludables –destacó la radical Brenda Austin-. De más está decir que la etiqueta actual es absolutamente insuficiente. Apenas un tercio de las personas las leen y la mitad de los que la leen las entienden”. ||| Desde la Coalición Cívica, Mariana Stilman dijo que esta ley, de ser aprobada, va en línea con lo que establece el artículo 42 de la Constitución Nacional. “Venimos a cumplir con el mandato constitucional que propicia el derecho a la alimentación saludable, información adecuada y veraz y libertad de elección y de los consumidores”, sostuvo. ||| Desde Pro, una de las pocas voces a favor del proyecto fue la de la diputada Gisela Scaglia. “Hoy las etiquetas son algo similar a un jeroglífico: tipografía pequeña casi ilegible. Este rotulado va en contra de nuestro derecho constitucional a la salud y al acceso a la información. Hoy vamos a cambiarlo para empezar a ser conscientes de lo que consumimos y terminar con el engaño”, enfatizó. ||| En contra del proyecto se pronunciaron las diputadas tucumana Beatriz Ávila (Justicia Social) e Ingrid Jetter (Pro). “Los tucumanos hemos sufrido mucho la agresión a nuestra industria madre, la azucarera, que le da trabajo a más de 30.000 personas. Este etiquetado negro remite a la muerte; pretender decir que el consumo de azúcar es similar al de la nicotina o a las grasas saturadas es insostenible. Por eso me pregunto cuáles son los intereses que motivan este proyecto”, advirtió Ávila. ||| “Esta ley es imperfecta e inútil -sostuvo Jetter-. El octógono informa sobre el exceso de determinado nutriente crítico, pero no en cuanto. Además, los productos con octógonos negros no pueden brindar información adicional sobre cualidades que puede tener ese producto”. ||| Sobre el final, Graciela Camaño (Consenso Federal) insistió en la necesidad de incorporar modificaciones a la media sanción del Senado. Advirtió que la norma no se armoniza con las regulaciones que al respecto rigen en los países en el Mercosur; asimismo, alertó que la iniciativa tampoco explicita cuáles serán los alimentos sujetos al nuevo etiquetado, si todos los alimentos o sólo los productos procesados y ultraprocesados. ||| “No se trata de hacer una revolución, simplemente se trata de instrumentar un buen etiquetado a los alimentos en la Argentina. Si ese es el objetivo y, al mismo tiempo, pretendemos preservar las fuentes de trabajo, dejémonos de jorobar con todos estos discursos pirotécnicos que sostienen que si no votás esta ley sos parte de un lobby. Somos un país del tercer mundo; no nos podemos dar el lujo de cerrar ningún puesto de trabajo más. Se me dirá que la reglamentación de la ley hará las correcciones que hacen falta; puede ser, pero estaremos renunciando a nuestra condición de legisladores”, enfatizó. ||| En términos generales, el proyecto de ley propone regular el etiquetado de los alimentos envasados al incorporar un esquema de rotulado que advierta cuando un determinado producto tenga exceso de nutrientes críticos en cinco categorías: grasas totales, grasas saturadas, sodio, azúcares y/o calorías. Para definir el umbral por sobre el cual se considera que un producto tiene nutrientes “en exceso”, la ley tomó como referencia el perfil de nutrientes diagramado por la Organización Panamericana de la Salud (OPS) que establece parámetros de consumo y alimentación. ||| Según esta iniciativa, las bebidas y los alimentos procesados deberán llevar octógonos negros de al menos un 5% del tamaño de la cara principal del envase cuando su composición supere un umbral mínimo en cada uno de estos componentes. Es decir, puede llevar uno o más sellos negros. ||| El objetivo es que el consumidor reconozca una advertencia sobre las características del producto. Chile (2016), Uruguay (2018), Perú (2019) y México (2020) son los países de la región con esquemas de advertencia similares al que se propone localmente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    ##  [8] "Extrañamente, Martín Guzmán se convirtió en un converso del cristinismo y Aníbal Fernández recobró, por un momento al menos, la sensatez política. Pueden ser los contradictorios destellos de un gobierno que se advierte más cerca de la ruina que de la gloria. Es un instante en el que La Cámpora se encierra aún más entre su escasa militancia, el albertismo ve llegar con ignorancia y desconfianza el día después de la derrota probable y el Presidente intuye que deberá atravesar otra “semana trágica”, como algunos funcionarios llaman a los días posteriores al desastroso 12 de septiembre pasado. ||| El destino del país se repliega en apenas 17 días, que son los días que faltan para las elecciones generales. El después es un arcano sin luz. “Cristina sabe lo que hará, pero no lo dice”, sostiene un funcionario de alto rango. Nadie está al tanto de lo que ella urde. ¿Puede haber desabastecimiento de alimentos? “No hasta el 14 de noviembre; veremos a partir del 15\", responde un empresario que frecuenta los despachos oficiales. Cada uno juega su propio partido, sobre todo dentro de la coalición gobernante. Parece un ejército que está por recibir la orden de retirada o que intuye que el combate está perdido. ||| Sin embargo, no hay peor kirchnerismo que el kirchnerismo desesperado. Roberto Feletti es la mejor expresión de la impotencia oficial. De un gobierno sin plan, pero también sin coherencia. Alberto Fernández recibió a importantes empresarios y los invitó a almorzar junto con la cúpula de La Cámpora (Máximo Kirchner y Eduardo “Wado” de Pedro). Pocos días después fue su administración la que comenzó la campaña contra los empresarios y fueron los camporistas los que restablecieron la ominosa práctica del escrache. Escracharon en las redes sociales a empresas productoras de alimentos que supuestamente no aceptaron la política de precios máximos y de control de precios. Lo hicieron señalando los nombres de las compañías y llamaron a no comprar sus productos. Esos escraches expandieron el temor entre renombrados empresarios. “Nadie sabe quién será el siguiente”, explica otro dirigente empresario. El hábito fue inaugurado por el patriarca muerto de la familia gobernante. Néstor Kirchner estrenó su presidencia con un boicot a la firma Shell porque esta no aceptaba los precios de las naftas que le indicaba el Gobierno. Usó a un dirigente piquetero, Luís D’Elía, y a un aparente dirigente empresario, Osvaldo Cornide, para concretar el boicot físico a la empresa petrolera. Fue solo la primera vez. El fascista escrache se transformó luego en un método habitual para señalar a enemigos y adversarios, a políticos y empresarios, a líderes sociales y a periodistas. ||| Un destacado dirigente empresario está convencido de que este es el peor momento de la relación entre ellos y un gobierno. ¿Peor que la que hubo con Guillermo Moreno? “Peor, responde, porque Moreno era patotero y maleducado, pero al final del día negociaba”. El líder fabril recuerda que también negociaron la dupla Axel Kicillof-Augusto Costa cuando estuvo al frente de la cartera económica. Miguel Braun, que fue secretario de Comercio con Macri, no dejó de negociar nunca el nivel de los precios. El actual ministro de Producción, Matías Kulfas, y la entonces secretaria de Comercio Paula Español también conversaban permanentemente con los empresarios. ¿Y Feletti? “Feletti es como Guillermo Moreno, pero sin negociación”, responde. Feletti dice que buscó un acuerdo con los empresarios para fijar precios máximos, pero nunca permitió el margen necesario para una negociación. Buscaba una rendición, no un acuerdo. ||| Intendentes, camporistas y movimientos sociales se dedican ahora a controlar precios. Son una especie rara de fuerzas de choque que arremeten contra los supermercados. No saben nada de economía ni de precios. La Secretaría de Comercio tiene inspectores formados para realizar esa tarea. El miedo es un herramienta más efectiva para el cristinismo. Los supermercados controlan un porcentaje importante de la oferta de alimentos, pero llega al 35 por ciento. El 65 por ciento restante está en mercados chicos o en negocios de cercanías; a estos no los controla nadie y pueden poner los precios que quieren. El control es, además, sobre el precio final que está en las góndolas de los supermercados; los proveedores de esos grandes centros comerciales pueden seguir remarcando los precios de los productos. La política de precios se convirtió en un macaneo más que en una política. En algunos productos, la retroactividad de los precios es al mes de julio, no al 1º de octubre como informó la Secretaría de Comercio. Los empresarios no saben si tener en cuenta el mes de julio o el de octubre. Entre uno y otro mes, hubo importantes incrementos en los índices inflacionarios. ||| La aparición más novedosa fue la del ministro de Economía, Guzmán, quien hizo suya la política de Feletti. “No hay dos políticas distintas, sino una sola”, dijo, y encima suscribió la versión conspiranoica del camporismo: “En la Argentina hay una colisión estructural de intereses”. Se refería a los intereses del capitalismo y los “del pueblo”. El ministro que vino a poner cierta moderación en la conducción económica y que prometió hacer lo que estudió en la cátedra (renegociar las deudas soberanas de los países), termina ahora convertido al fanatismo cristinista. Empujado por la decisión de conservar el cargo, no bregó por la moderación de la coalición que lo ungió. Hizo al revés: se radicalizó él mismo junto con el ala más radicalizada del Gobierno. Guzmán fue el descubrimiento de Alberto Fernández; será también su decepción. ||| La eventual derrota debe tener un culpable: es la oposición. Victoria Tolosa Paz dejó de hablar –en buena hora– del sexo de los peronistas, pero se dedica a denunciar un “golpe blando” que, según ella, programan los opositores para antes del 14 de noviembre. Golpe blando es una definición relativamente nueva que refiere a procesos de desestabilización de los gobiernos con métodos no violentos. La democracia argentina soportó crisis como las hiperinflaciones de fines de los 80 y principios de los 90 o el gran colapso de 2001/2002, que hasta requirió el reemplazo del expresidente Fernando de la Rúa, que renunció provocando la crisis política e institucional más grave desde 1983. Nunca estuvo en duda el sistema democrático ni el respeto a los mecanismos previstos por la Constitución. ¿Cómo calificaríamos entonces las marchas kirchneristas durante el gobierno de Macri, que portaban la maqueta de un helicóptero en alusión a la forma en que De la Rúa se fue de la Casa de Gobierno después de renunciar? Era un clamor para que Macri renunciara y se fuera en un helicóptero. ¿Eso era un golpe blando o un golpe duro? El golpe más claro y certero contra Alberto Fernández lo dio la propia Cristina Kirchner, vicepresidenta y jefa política de la coalición gobernante, cuando escribió la carta posterior a la derrota del 12 de septiembre. Con esas pocas líneas arrebatadas le cambió el gabinete al Presidente. Golpe duro, sin duda. ||| Aníbal Fernández morigeró a Tolosa Paz y volvió por un instante a ser el traqueteado político que fue. “La política es así. No vivimos entre algodones”, descalificó a la candidata bonaerense. La política es así, en efecto. Cargada de ambiciones y especialmente implacable en tiempos electorales. Esa realidad la conocían bien Raúl Alfonsín, Carlos Menem, Eduardo Duhalde y el propio Macri. Nunca se los escuchó hablar de conspiraciones ni de persecuciones. No carecieron de enemigos ni de conjuras ni de intrigas, pero entendieron que esas cosas forman parte de la vida que eligieron. Solo con el kirchnerismo se inauguró un período de constantes denuncias de supuestos golpismos o de actitudes destituyentes. El fracaso propio debe tener un nombre ajeno. ||| La fijación en la venganza es la única obsesión permanente (y coherente) del cristinismo que gobierna. Macri deberá concurrir mañana a los tribunales de Dolores para responder a una indagatoria del juez federal Martín Bava. Lo citó en un expediente por el supuesto seguimiento a familiares de las víctimas del submarino ARA San Juan. Bava es un juez en los Civil de Azul que subroga un juzgado penal en Dolores; hay pocos jueces con peores antecedentes académicos que Bava. En esa causa, ningún testigo nombró a Macri ni ninguna prueba lo señala al expresidente. Su nombre está solo escrito en las primeras líneas de la inicial denuncia. El juez entendió, a pesar de todo, que si hubo seguimiento Macri debió saberlo o debió autorizarlo. Una inferencia que contradice cada línea del Código Penal argentino. Macri pidió el apartamiento de Bava y este pasó el reclamo, como corresponde, a la Cámara Federal de Mar del Plata, su superior, para que lo acepte o lo rechace. En tales casos, los jueces suelen detener su instrucción hasta que la Cámara se expide. Bava es la excepción: mandó el pedido a la Cámara, pero él sigue actuando como juez. Urgencias electorales. ||| Hay un solo funcionario que no piensa en derrotas ni en victorias, sino en la venganza: es Carlos Zannini, procurador del Tesoro, jefe de los abogados del Estado. Acaba de pedir que en el marco del largo proceso judicial por el caso del Correo, propiedad de la familia Macri desde los años 90, se declare también la quiebra de Socma, la casa matriz de todas las empresas de la familia del expresidente. El caso del Correo está en la Corte Suprema para que esta decida si se resolverá en los tribunales federales o en los de la Capital. La Corte debería decidir cuanto antes sobre el tema para no permitir que exista el revanchismo en la política argentina y, sobre todo, que se use a la justicia para esos fines innobles. ||| Exfuncionarios de Macri recibieron la propuesta de empinados kirchneristas para que lo incriminen al expresidente a cambio de liberarlos de cualquier desventura judicial. Una exfuncionaria les contestó con una frase corta y definitiva: “Hay un problema: yo tendría que nacer de nuevo para hacer eso”. Hay también una paradoja: Macri es al parecer el autor del golpe blando contra el kirchnerismo, pero es, al mismo tiempo, quien caminará mañana por el corredor destinado a las revanchas del kirchnerismo."
    ##  [9] "Según un reciente estudio de opinión, la palabra más utilizada para definir al presidente Alberto Fernández es “títere”. Así se desprende del último estudio de opinión realizado por la consultora Giacobbe y Asociados. En cambio, el término que más caracteriza a la vicepresidenta es “corrupta”. ||| “Las palabras más recurrentes para definir a Cristina Fernández de Kirchner son corrupta, ladrona, chorra, delincuenta. Es una nube bastante homogénea”, consideró Giacobbe al presentar los estudios en el programa Mesa Chica de LN+, conducido por José Del Rio. ||| El especialista señaló que, en segundo término, aparecen los términos “líder” o \" estadista” que se corresponde con aquellos que destacan su figura y que pertenecen al grupo “de menos del 30% que tiene una imagen positiva de ella”. ||| Sobre la metodología, Giacobbe aclaró que se les pide a los encuestados que “defina en una palabra” a los dirigentes. “Le damos un espacio en blanco y la gente escribe lo que quiere”, ahondó. ||| En tanto, el consultor sostuvo que la nube de palabras vinculada a Alberto Fernández es “más dispersa y diversa”, aunque también tiene “imputaciones” como en el caso de Cristina Kirchner. “Se utiliza títere, inútil, y mentiroso, en particular”, apuntó. ||| En ese sentido, Giaccobe analizó: “Corrupto no está [en el caso de Alberto Fernández]. Ahora, en [la nube de] Cristina Kirchner no está ni títere, ni inútil ni mentirosa”. Y precisó que “no es lo mismo” ser tildado de “malo” que de no cumplir con la función. ||| En el caso de la figura presidencial, Giacobbe sostuvo que la palabra “títere” proviene de su relación con la vicepresidenta, mientras que “inútil” está vinculada a que la sociedad no lo considera “una herramienta útil para solucionar los problemas que la angustian”. ||| En tanto, reparó también en el concepto de mentiroso. “Viene de la parte del público que creyó que podía ser un hombre moderado, peronista, un hombre de corte liberal”, explicó. ||| En ese sentido, consignó: “Alberto y Cristina nos dan la misma nube de palabras que la diferencia entre [Hugo] Chávez y [Nicolás] Maduro, cuando hemos medido a Venezuela”. ||| Tambié presente en el piso de LN+, el director de Opina Argentina, Facundo Nejamkis, dio cuenta de un sondeo que expone otro aspecto de la grieta en el país. La pregunta sobre cuál es el sector político más preparado para reactivar la economía arrojó un empate entre Juntos por el Cambio y el Frente de Todos en la provincia de Buenos aires. ||| Según el trabajo, un 34% opina que Juntos por el Cambio es el sector más preparado para recuperar la economía en una situación de pospandemia. En tanto, un 33% eligió al Frente de Todos. A su vez, un 26% evitó definirse por alguno de los dos espacios, mientras que un 7% quedó encasillado bajo el “No sabe/no contesta”. ||| “Por primera vez Juntos aparece por encima del Frente de Todos”, expuso Nejamkis. El consultor señaló que esa respuesta choca con “el principal atributo que tiene en el peronismo, especialmente en la provincia, que es el de fuerza política preparada para gobernar”. ||| Asimismo, identificó otros dos datos. “El primero es que Juntos muy rápidamente se recupera del final del gobierno de Mauricio Macri, que fue muy duro para esa fuerza política. Y aparece como una fuerza muy competitiva” señaló. ||| Por otro lado, indicó que el otro punto es que hay un tercio de la población que “ya no cree en las fuerzas políticas principales”. “Es el 26% [que no elige a ninguno] más el 7% [que evita responder], que se muestran escépticos frente a las dos principales coaliciones que dominaron que dominaron la política argentina en los últimos diez años”, añadió. Y señaló que es una oportunidad para sectores emergentes como el movimiento liberal."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    ## [10] "La candidata del Frente de Todos Victoria Tolosa Paz se refirió anoche al video en el que aparece haciendo compras en un shopping, acompañada de su marido Enrique “Pepe” Albistur. “No tengo por qué someterme al escarnio público”, dijo la candidata del oficialismo. ||| En declaraciones a Canal Nueve Tolosa Paz relativizó la polémica y las críticas que recibió sobre las imágenes. Cuando se la consultó sobre el video, en donde se ve a la pareja con una importante cantidad de bolsas, expresó: “Voy a seguir haciendo mi vida como todos los días”. ||| Además, la titular del Consejo del Hambre aclaró que el video es de hace un mes atrás. “Fue antes de las elecciones. Pasé por un shopping y compré regalos para las hijas de mi marido y mis nietos, tengo todo el derecho del mundo de comprar lo que quiero”, esgrimió Tolosa Paz. ||| El “golpe blando” lo está dando Derrota Tolosa Paz en el shopping <U+0001F449> pic.twitter.com/Hkx6zGwgnu ||| “Quiero seguir siendo quien fui, administro mi hogar, hago las compras y mandados. Si alguien elige viralizarlo voy a seguir caminando las calles de la Argentina”, expresó la candidata del Frente de Todos. ||| En esta línea, Tolosa Paz apuntó contra la candidata de Juntos por el Cambio María Eugenia Vidal y la controversia que se generó alrededor de la compra de un departamento. “Yo puedo dar cuenta de mi patrimonio”, dijo, y acusó a la exgobernadora de no poder explicar la compra del inmueble. “Hay inconsistencia en su declaración”, agregó. ||| La aspirante a legisladora acusó esta semana a Juntos por el Cambio de estar preparando un “golpe blando” antes de las elecciones legislativas del 14 de noviembre, y en medio de sus declaraciones, apareció el video del shopping que fue difundido por usuarios en redes sociales. ||| Frente a estas imágenes, Tolosa Paz responsabilizó por la difusión del video “al ejército de trolls de Marquitos Peña” por el exjefe de Gabinete del entonces presidente Mauricio Macri. E involucró al jefe de Gobierno de la Ciudad de Buenos Aires, Horario Rodríguez Larreta, y al candidato a diputado por Juntos por el Cambio Diego Santilli. ||| La candidata a diputada del oficialismo fue consultada sobre la declaración sobre que la oposición se encontraba llevando adelante un “golpe blando”. Lo había dicho en una entrevista con AM 750. Sobre esto, Tolosa Paz reclamó: “Nos quieren dar cátedra en lugar de tener un poco de humildad, un poco de responsabilidad”. ||| En esta línea, reafirmó sus dichos al considerar que la oposición lleva adelante “intentos de desestabilizar económicamente, intentos de devaluar la moneda, intentos constantes y sonantes”. Y concluyó: “En el mundo se llaman golpes blandos, dañar al gobierno de turno en busca de construir un rédito”."

Hemos logrado lo que queríamos, extraer información semi-estructurada de
internet y transformar esa información en datos dentro de un marco de
datos de tipo tabular (tabla). ¡Bien hecho!

### Ejercicio 3

Ahora nos toca avanzar en otro de los enfoque para desarrollar web
scraping. Cuando las páginas no explicitan su url y necesitamos
interactuar con el navegador sí o sí, se vuelve necesario el auxilio del
paquete `RSelenium`.

![](https://estudiosmaritimossociales.org/Data_TalleR/la_nacion_selenium.png)

Este paquete, junto con `rvest`, nos permite scrapear páginas dinámicas.
Hay que tener en cuenta que este enfoque falla más y es más lento.

    # Pueden copiar y pegar o descargarlo desde RStudio con esta línea de comando:
    # utils::download.file("https://estudiosmaritimossociales.org/ejercicio03.R", "ejercicio03.R")
    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(tidyverse)
    require(rvest)
    # install.packages("RSelenium") (si no lo tienen instalado)
    require(RSelenium) 
    # El objetivo de RSelenium es facilitar la conexión a un servidor remoto desde dentro de R. 
    # RSelenium proporciona enlaces R para el API de Selenium Webdriver. 
    # Selenio es un proyecto centrado en la automatización de los navegadores web. 
    # Descargamos los binarios, iniciamos el controlador y obtenemos el objeto cliente.
    servidor <- RSelenium::rsDriver(browser = "firefox", port = 2345L) # iniciar un servidor y un navegador de Selenium

    ## [1] "Connecting to remote server"
    ## $acceptInsecureCerts
    ## [1] FALSE
    ## 
    ## $browserName
    ## [1] "firefox"
    ## 
    ## $browserVersion
    ## [1] "92.0.1"
    ## 
    ## $`moz:accessibilityChecks`
    ## [1] FALSE
    ## 
    ## $`moz:buildID`
    ## [1] "20210922161155"
    ## 
    ## $`moz:geckodriverVersion`
    ## [1] "0.30.0"
    ## 
    ## $`moz:headless`
    ## [1] FALSE
    ## 
    ## $`moz:processID`
    ## [1] 8740
    ## 
    ## $`moz:profile`
    ## [1] "C:\\Users\\agust\\AppData\\Local\\Temp\\rust_mozprofilevC2xv3"
    ## 
    ## $`moz:shutdownTimeout`
    ## [1] 60000
    ## 
    ## $`moz:useNonSpecCompliantPointerOrigin`
    ## [1] FALSE
    ## 
    ## $`moz:webdriverClick`
    ## [1] TRUE
    ## 
    ## $pageLoadStrategy
    ## [1] "normal"
    ## 
    ## $platformName
    ## [1] "windows"
    ## 
    ## $platformVersion
    ## [1] "10.0"
    ## 
    ## $proxy
    ## named list()
    ## 
    ## $setWindowRect
    ## [1] TRUE
    ## 
    ## $strictFileInteractability
    ## [1] FALSE
    ## 
    ## $timeouts
    ## $timeouts$implicit
    ## [1] 0
    ## 
    ## $timeouts$pageLoad
    ## [1] 300000
    ## 
    ## $timeouts$script
    ## [1] 30000
    ## 
    ## 
    ## $unhandledPromptBehavior
    ## [1] "dismiss and notify"
    ## 
    ## $webdriver.remote.sessionid
    ## [1] "81517b5b-b353-40c1-8160-e0232d5ec79e"
    ## 
    ## $id
    ## [1] "81517b5b-b353-40c1-8160-e0232d5ec79e"

    cliente <- servidor$client                                         # objeto 'cliente' (objeto que contiene un vínculo dinámico con el servidor)
    cliente$navigate("https://www.lanacion.com.ar/politica")           # cargamos la página a navegar
    # Ahora debemos encontrar el botón de carga y hacemos clic sobre él.
    VerMas <- cliente$findElement(using = "css selector", ".col-12.--loader") # Encontramos el botón
    for (i in 1:6){                 # abrimos función for() para reiterar n veces la acción (clic)
      
      base::print(i)                # imprimimos cada acción
      
      VerMas$clickElement()         # hacemos clic
      
      base::Sys.sleep(7)            # estimamos tiempo de espera entre clic y clic
      
    }                               # cerramos la función for()

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6

    html_data <- cliente$getPageSource()[[1]]                          # obtenemos datos HTML y los analizamos
    ln_sec_pol <- html_data %>%                                        # obtenemos los links a las notas de la sección Política
      
      rvest::read_html() %>%                                           # leemos el objeto html_data con la función read_html()
      
      rvest::html_elements("h2.com-title.--xs a.com-link") %>%         # ubicamos los tags de los links a las notas
      
      rvest::html_attr("href") %>%                                     # extraemos los links de las notas
      
      rvest::url_absolute("https://www.lanacion.com.ar/politica") %>%  # llamo a la función url::absolute() para completar las URLs relativas
      
      tibble::as_tibble() %>%                                          # llamo a la función as_tibble() para transformar el objeto en una tibble.
      
      dplyr::rename(link = value)                                      # llamo a la función rename() para renombrar la variable creada.
    # Creamos la función scraping_notas() para scrapear los links obtenidos ---------------------
    scraping_notas <- function(pag_web, tag_fecha, tag_titulo, tag_nota) { # abro función para raspado web: scraping_notas().
      
      tibble::tibble(                               # llamo a la función tibble.
      
      fecha = rvest::html_elements(                 # declaro la variable fecha y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_fecha) %>%   # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) de la fecha. 
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' de la fecha.
      
      titulo = rvest::html_elements(                # declaro la variable `titulo` y llamo a la función html_elements().
        
        rvest::read_html(pag_web), tag_titulo) %>%  # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) del título.  
        
        rvest::html_text(),                         # llamo a la función html_text() para especificar el formato 'chr' del título.
      
      nota = rvest::html_elements(                  # declaro la variable nota y llamo a la función html_elements(). 
        
        rvest::read_html(pag_web), tag_nota) %>%    # llamo a la función read_html(pag_web) y especifico la(s) etiqueta(s) de la nota.  
        
        rvest::html_text()                          # llamo a la función html_text() para especificar el formato 'chr' de la nota.
      
      )                                             # cierro la función tibble().
      
    }                                               # cierro la función para raspado web.
    # Usamos la función pmap_dfr() para emparejar los links y la función de web scraping y 
    # creamos el objeto la_nacion_politica con 20 notas completas
    (la_nacion_politica <- purrr::pmap_dfr(list(ln_sec_pol$link[1:20],".com-date.--twoxs",".com-title.--threexl",".col-12 p"), scraping_notas))

    ## # A tibble: 236 x 3
    ##    fecha                 titulo                   nota                          
    ##    <chr>                 <chr>                    <chr>                         
    ##  1 27 de octubre de 2021 Nadie sabe qué hará la ~ Extrañamente, Martín Guzmán s~
    ##  2 27 de octubre de 2021 Nadie sabe qué hará la ~ El destino del país se replie~
    ##  3 27 de octubre de 2021 Nadie sabe qué hará la ~ Sin embargo, no hay peor kirc~
    ##  4 27 de octubre de 2021 Nadie sabe qué hará la ~ Un destacado dirigente empres~
    ##  5 27 de octubre de 2021 Nadie sabe qué hará la ~ Intendentes, camporistas y mo~
    ##  6 27 de octubre de 2021 Nadie sabe qué hará la ~ La aparición más novedosa fue~
    ##  7 27 de octubre de 2021 Nadie sabe qué hará la ~ La eventual derrota debe tene~
    ##  8 27 de octubre de 2021 Nadie sabe qué hará la ~ Aníbal Fernández morigeró a T~
    ##  9 27 de octubre de 2021 Nadie sabe qué hará la ~ La fijación en la venganza es~
    ## 10 27 de octubre de 2021 Nadie sabe qué hará la ~ Hay un solo funcionario que n~
    ## # ... with 226 more rows

    # Guardamos el objeto 'la_nacion_politica' como objeto .rds
    base::saveRDS(la_nacion_politica, "la_nacion_politica.rds")

### Ejercicio 4

No todo es información suelta y poco estructurada. El lenguaje HTML
tiene un objeto que presenta su contenido en formato tabular, nos
referimos a las tablas HTML que tienen las etiquetas
<table>
</table>

. Es verdad que muchas de estas tablas tiene la opción de descarga en
formato `csv` u otro similar, pero no siempre es así. Inspeccionemos un
poco.

En Wikipedia, un sitio hiper consultado, las tablas no tren por defecto
la opción de descarga. A ver…

![](https://estudiosmaritimossociales.org/Data_TalleR/wiki.png)

Ahí están los datos sobre población mundial. Los queremos pero no los
podemos bajar en ningún formato. Podemos copiar y pegar o ‘rasparlos’ de
forma automática…

    # Pueden copiar y pegar o descargarlo desde RStudio con esta línea de comando:
    # utils::download.file("https://estudiosmaritimossociales.org/ejercicio04.R", "ejercicio04.R")
    # Paquetes a cargar (función 'require()' es equivalente a la función 'library()') ----------------
    require(dplyr)
    require(rvest)
    require(tibble)
    # Creamos la función para raspar El País cuyo nombre será 'scraping_links()' ---------------------
    url_wiki <- "https://es.wikipedia.org/wiki/Población_mundial"  # creamos el objeto url_wiki con la url de la pág. web que contiene las tablas
    (pob__mun__t_tablas <- rvest::read_html(url_wiki) %>%          # creamos un objeto y llamamos a la función read_html() para leer la pág. web.
        
      rvest::html_table())                                         # llamamos a la función html_table() para quedarnos con todas las tablas existentes.

    ## [[1]]
    ## # A tibble: 6 x 6
    ##   Continente `Densidad(hab./~ `Superficie(km²~ `Población(2020~ `País más pobla~
    ##   <chr>      <chr>            <chr>            <chr>            <chr>           
    ## 1 Asia       106,8            44.010.000       4.701.010.000    China (1.440.00~
    ## 2 África     43,4             30.370.000       1.320.000.000    Nigeria (209.20~
    ## 3 América    25,3             43.316.000       1.098.064.000    Estados Unidos ~
    ## 4 Europa     78,6             10.180.000       801.000.000      Rusia (112.000.~
    ## 5 Oceanía    4,46             9.008.500        40.201.000       Australia (27.2~
    ## 6 Antártida  0,0003(varía)    13.720.000       4.490(no perman~ N.D.[nota 1]<U+200B>    
    ## # ... with 1 more variable: Ciudad más poblada(2020) <chr>
    ## 
    ## [[2]]
    ## # A tibble: 29 x 9
    ##    Año         Total         África        Asia  Europa América Oceanía `Crecimientoent~
    ##    <chr>       <chr>         <chr>         <chr> <chr>  <chr>   <chr>   <chr>           
    ##  1 10000 a. C. 1 000 000     ""            ""    ""     ""      ""      ""              
    ##  2 8000 a. C.  8 000 000     ""            ""    ""     ""      ""      ""              
    ##  3 1000 a. C.  50 000 000    ""            ""    ""     ""      ""      ""              
    ##  4 500 a. C.   100 000 000   ""            ""    ""     ""      ""      ""              
    ##  5 1 d.C.      200 000 000   ""            ""    ""     ""      ""      ""              
    ##  6 1000        310 000 000   ""            ""    ""     ""      ""      ""              
    ##  7 1750        791 000 000   "106 000 000" "502~ "163 ~ "18 00~ "2 000~ ""              
    ##  8 1800        978 000 000   "107 000 000" "635~ "203 ~ "31 00~ "2 000~ "23,64%"        
    ##  9 1850        1 262 000 000 "111 000 000" "809~ "276 ~ "64 00~ "2 000~ "29,04%"        
    ## 10 1900        1 650 000 000 "133 000 000" "947~ "408 ~ "156 0~ "6 000~ "30,74%"        
    ## # ... with 19 more rows, and 1 more variable: Crecimientoanual medio (%) <chr>
    ## 
    ## [[3]]
    ## # A tibble: 1 x 2
    ##   X1                     X2                                                     
    ##   <chr>                  <chr>                                                  
    ## 1 Control de autoridades "Proyectos Wikimedia\n Datos: Q11188\n Multimedia: Wor~

    (pob_mun_tablas_1y2 <- rvest::read_html(url_wiki) %>%          # creamos un objeto y llamamos a la función read_html() para leer la pág. web.
        
      rvest::html_table() %>% .[1:2])                              # llamamos a la función html_table() e indicamos con qué tablas queremos quedarnos.

    ## [[1]]
    ## # A tibble: 6 x 6
    ##   Continente `Densidad(hab./~ `Superficie(km²~ `Población(2020~ `País más pobla~
    ##   <chr>      <chr>            <chr>            <chr>            <chr>           
    ## 1 Asia       106,8            44.010.000       4.701.010.000    China (1.440.00~
    ## 2 África     43,4             30.370.000       1.320.000.000    Nigeria (209.20~
    ## 3 América    25,3             43.316.000       1.098.064.000    Estados Unidos ~
    ## 4 Europa     78,6             10.180.000       801.000.000      Rusia (112.000.~
    ## 5 Oceanía    4,46             9.008.500        40.201.000       Australia (27.2~
    ## 6 Antártida  0,0003(varía)    13.720.000       4.490(no perman~ N.D.[nota 1]<U+200B>    
    ## # ... with 1 more variable: Ciudad más poblada(2020) <chr>
    ## 
    ## [[2]]
    ## # A tibble: 29 x 9
    ##    Año         Total         África        Asia  Europa América Oceanía `Crecimientoent~
    ##    <chr>       <chr>         <chr>         <chr> <chr>  <chr>   <chr>   <chr>           
    ##  1 10000 a. C. 1 000 000     ""            ""    ""     ""      ""      ""              
    ##  2 8000 a. C.  8 000 000     ""            ""    ""     ""      ""      ""              
    ##  3 1000 a. C.  50 000 000    ""            ""    ""     ""      ""      ""              
    ##  4 500 a. C.   100 000 000   ""            ""    ""     ""      ""      ""              
    ##  5 1 d.C.      200 000 000   ""            ""    ""     ""      ""      ""              
    ##  6 1000        310 000 000   ""            ""    ""     ""      ""      ""              
    ##  7 1750        791 000 000   "106 000 000" "502~ "163 ~ "18 00~ "2 000~ ""              
    ##  8 1800        978 000 000   "107 000 000" "635~ "203 ~ "31 00~ "2 000~ "23,64%"        
    ##  9 1850        1 262 000 000 "111 000 000" "809~ "276 ~ "64 00~ "2 000~ "29,04%"        
    ## 10 1900        1 650 000 000 "133 000 000" "947~ "408 ~ "156 0~ "6 000~ "30,74%"        
    ## # ... with 19 more rows, and 1 more variable: Crecimientoanual medio (%) <chr>

    (pob__mun__tabla__1 <- rvest::read_html(url_wiki) %>%          # creamos un objeto y llamamos a la función read_html() para leer la pág. web.
        
      rvest::html_table() %>% .[[1]])                              # llamamos a la función html_table() e indicamos con qué tabla queremos quedarnos.

    ## # A tibble: 6 x 6
    ##   Continente `Densidad(hab./~ `Superficie(km²~ `Población(2020~ `País más pobla~
    ##   <chr>      <chr>            <chr>            <chr>            <chr>           
    ## 1 Asia       106,8            44.010.000       4.701.010.000    China (1.440.00~
    ## 2 África     43,4             30.370.000       1.320.000.000    Nigeria (209.20~
    ## 3 América    25,3             43.316.000       1.098.064.000    Estados Unidos ~
    ## 4 Europa     78,6             10.180.000       801.000.000      Rusia (112.000.~
    ## 5 Oceanía    4,46             9.008.500        40.201.000       Australia (27.2~
    ## 6 Antártida  0,0003(varía)    13.720.000       4.490(no perman~ N.D.[nota 1]<U+200B>    
    ## # ... with 1 more variable: Ciudad más poblada(2020) <chr>

    (pob__mun__tabla__2 <- rvest::read_html(url_wiki) %>%          # creamos un objeto y llamamos a la función read_html() para leer la pág. web.
        
      rvest::html_table() %>% .[[2]])                              # llamamos a la función html_table() e indicamos con qué tabla queremos quedarnos.

    ## # A tibble: 29 x 9
    ##    Año         Total         África        Asia  Europa América Oceanía `Crecimientoent~
    ##    <chr>       <chr>         <chr>         <chr> <chr>  <chr>   <chr>   <chr>           
    ##  1 10000 a. C. 1 000 000     ""            ""    ""     ""      ""      ""              
    ##  2 8000 a. C.  8 000 000     ""            ""    ""     ""      ""      ""              
    ##  3 1000 a. C.  50 000 000    ""            ""    ""     ""      ""      ""              
    ##  4 500 a. C.   100 000 000   ""            ""    ""     ""      ""      ""              
    ##  5 1 d.C.      200 000 000   ""            ""    ""     ""      ""      ""              
    ##  6 1000        310 000 000   ""            ""    ""     ""      ""      ""              
    ##  7 1750        791 000 000   "106 000 000" "502~ "163 ~ "18 00~ "2 000~ ""              
    ##  8 1800        978 000 000   "107 000 000" "635~ "203 ~ "31 00~ "2 000~ "23,64%"        
    ##  9 1850        1 262 000 000 "111 000 000" "809~ "276 ~ "64 00~ "2 000~ "29,04%"        
    ## 10 1900        1 650 000 000 "133 000 000" "947~ "408 ~ "156 0~ "6 000~ "30,74%"        
    ## # ... with 19 more rows, and 1 more variable: Crecimientoanual medio (%) <chr>

    saveRDS(pob_mun_tablas_1y2, 'pob_mun_tablas_1y2.rds')          # guardamos como archivo .rds la lista con los dos tibbles.

Pudimos bajar las dos tablas con datos referidos a la población mundial.
Con este ejercicio concluimos el capítulo sobre web scraping.

#### En este link les dejo una app para Web Scraping de notas sobre conflictos en el portal de noticias marplatense 0223.com. Lo hicimos con el paquete \`shiny’ de RStudio.

##### [Raspador web en tiempo real con R](https://gesmar-mdp.shinyapps.io/WebScrapingAppR/)

## Otros paquetes para hacer Web Scraping en R

-   [ralger (paquete de reciente
    creación, 2019)](https://github.com/feddelegrand7/ralger)
-   [RCrawler](https://github.com/salimk/Rcrawler)
-   [ScrapeR (no está
    actualizado)](https://github.com/mannau/tm.plugin.webmining)
-   [tm.plugin.webmining (no está
    actualizado)](https://cran.r-project.org/web/packages/scrapeR/scrapeR.pdf)

## Bibliografía de referencia

-   [Olgun Aydin (2018) *R web Scraping Quick Start
    Guide*](https://books.google.es/books?hl=es&lr=&id=Iel1DwAAQBAJ&oi=fnd&pg=PP1&dq=#v=onepage&q&f=false)
-   [Alex Bradley & Richard J. E. James (2019) *Web Scraping Using
    R*](https://journals.sagepub.com/doi/pdf/10.1177/2515245919859535)
-   [Mine Dogucu & Mine Çetinkaya-Rundel (2020) *Web Scraping in the
    Statistics and Data Science Curriculum: Challenges and
    Opportunities*](https://www.tandfonline.com/doi/pdf/10.1080/10691898.2020.1787116?needAccess=true)
-   [Subhan Khaliq (2020) *Web Scraping in
    R*.](https://medium.com/analytics-vidhya/web-scraping-in-r-cbb771cd0061)
-   [Simon Munzert, Christian Rubba, Peter Meißner & Dominic
    Nyhuis (2015) *Automated Data Collection with R: A Practical Guide
    to Web Scraping and Text
    Mining*](https://estudiosmaritimossociales.org/R_web_scraping.pdf)
-   [Steve Pittard (2020) *Web Scraping with
    R*.](https://steviep42.github.io/webscraping/book/)
