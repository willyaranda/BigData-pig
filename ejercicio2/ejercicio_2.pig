/* Register lib */
register '../libs/elephant-bird-pig-3.0.7.jar';

/* And needed libs for elephant to work, dependencies are really fun */
register '../libs/json-simple-1.1.1.jar';
register '../libs/slf4j-api-1.7.5.jar';
register '../libs/slf4j-simple-1.7.5.jar';

/* Define a nice name for the function we are going to use */
Define JsonStringToMap com.twitter.elephantbird.pig.piggybank.JsonStringToMap();

/* Load data */
orders_data = load '../orders.data' USING PigStorage('@') AS (id_tienda:bytearray, id_usuario:bytearray, json:chararray);
/* Parse data */
parsed = foreach orders_data generate id_tienda, id_usuario, JsonStringToMap(json)#'date' as date, JsonStringToMap(json)#'amount' as amount;
/* And save it*/
store_data = STORE parsed INTO 'amountBydate.out' USING PigStorage(',');
