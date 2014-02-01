/*
  Load data from parent directory and store in memory with the following structure
*/
load_orders = load '../orders.data' USING PigStorage('@') AS (id_tienda:bytearray, id_usuario:bytearray, json:chararray);
/*
  Save the data into 'ejercicio1a' (which is a directory), separated by commas (CSV-like)
*/
store_a = STORE load_orders INTO 'ejercicio1a' USING PigStorage(',');
load_sessions = load '../sessions.data' USING PigStorage('@') AS (id_tienda:bytearray, id_usuario:bytearray, json:chararray);
store_sessions = STORE load_sessions INTO 'ejercicio1b' USING PigStorage(',');
