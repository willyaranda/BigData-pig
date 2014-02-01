register '../libs/elephant-bird-pig-3.0.7.jar';

/* And needed libs for elephant to work, dependencies are really fun */
register '../libs/json-simple-1.1.1.jar';
register '../libs/slf4j-api-1.7.5.jar';
register '../libs/slf4j-simple-1.7.5.jar';
Define JsonStringToMap com.twitter.elephantbird.pig.piggybank.JsonStringToMap();

/* Load data */
load_sessions = load '../sessions.data' USING PigStorage('@') AS (
    id_tienda:bytearray,
    totalPagVisits:bytearray,
    json:chararray);
/* Generate needed data */
generated_data = foreach load_sessions generate id_tienda,
    totalPagVisits,
    JsonStringToMap(json)#'actionName' as actionName;

/* Filter products and pages based on the actionName */
Productos = FILTER generated_data BY actionName == 'productNav';
Paginas = FILTER generated_data BY actionName == 'pageNav';

/* Let's group them by id_tienda */
groupProductos = GROUP Productos BY id_tienda;
groupPages = GROUP Paginas BY id_tienda;

/* Generate the counters for each tienda */
ContadorProductos = FOREACH groupProductos GENERATE $0, COUNT(Productos);
ContadorPaginas = FOREACH groupPages GENERATE $0, COUNT(Paginas);

/* Join all them together */
total = JOIN ContadorPaginas by $0 FULL OUTER, ContadorProductos by $0;

/* And make it beauty and save*/
final = FOREACH total generate (($0 is not null) ? $0 : $2),
                               (($1 is not null) ? $1 : 0),
                               (($3 is not null) ? $3 : 0);
stored = STORE final INTO 'join.out' USING PigStorage(',');
