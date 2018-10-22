# Material del taller "Enfoques digitales" (23 de octubre de 2018)

Aquí se encuentran unos recursos necesarios para la práctica experimental con el reconocimiento de entidades nombradas 
(lugares) en el archivo XML de una obra de la Escuela de Salamanca (Bartolomé de Albornoz: Arte de los contractos. Valencia 1573).

El archivo XML de la obra es el documento  "Albornoz_Contractos.xml"; 
nombres de lugares en el texto de este documento serán anotados automáticamente por el programa XSLT "NER_lugares.xsl" 
que busca y anota los nombres. Para éste el programa requiere una lista de nombres de lugares que son predefinidas en el
archivo CSV "lugares.csv". 
Este archivo contiene nombres de lugares y (en parte) también números de identificación de los nombres del tesauro Getty 
(http://www.getty.edu/research/tools/vocabularies/tgn/index.html) junto con formas normalizadas (en inglés) de nombres.
Después de descargar los materiales, se puede efectuar el anotación automatica con el comando sucesivo en la línea de comandos 
(con tal que la línea de comandos esté navegada al sendero en el cual se encuentra la tarpeta 
descargada y descomprimida "taller-enfoquesdigitales-master"):

java -cp lib/SaxonHE9-9-0-1J/saxon9he.jar net.sf.saxon.Transform -s:Albornoz_Contractos.xml -xsl:NER_lugares.xsl -o:Albornoz_Contractos_procesado.xml

El comando produce un archivo procesado "Albornoz_Contractos.xml". Nombres predefinidos en 
la lista "lugares.csv" son anotados en este archivo con la etiqueta 
```xml
<placeName ref="123456" key="nombre">lugar</placeName>
```
o simplemente 
```xml
<placeName>lugar</placeName>
```
(si el número de identificación 
y la forma normalizada aún no están entregadas en la lista CSV).

El procesamiento de la manera mencionada arriba requiere la plataforma "Java" (https://www.java.com/es/download/). Ayudo en cuanto a la navegación en 
la línea de comandos se encuentra por ejemplo aquí: https://tutorial.djangogirls.org/es/intro_to_command_line/
