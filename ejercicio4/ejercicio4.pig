register '../libs/piggybank-0.3-amzn.jar';
register '../libs/elephant-bird-pig-3.0.7.jar';
register '../libs/js.jar';

/* And needed libs for elephant to work, dependencies are really fun */
register '../libs/json-simple-1.1.1.jar';
register '../libs/slf4j-api-1.7.5.jar';
register '../libs/slf4j-simple-1.7.5.jar';

/* Define common functions */
--register 'funcs.py' using jython as myfuncs;
register 'funcs.js' using javascript as myfuncs;

/* Load data and generate the needed data */
load_orders = load '../orders.data' USING PigStorage('@') AS (id_tienda:bytearray, id_usuario:bytearray, json:chararray);
load_generated = foreach load_orders generate id_tienda,
											  id_usuario,
	                                          myfuncs.CountProducts(json) as numProducts;

dump load_generated;