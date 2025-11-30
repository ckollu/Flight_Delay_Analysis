CREATE DATABASE IF NOT EXISTS aviation_analysis; 
SELECT @@sql_mode;
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
USE aviation_analysis;
drop table raw_flights;
SHOW FULL TABLES IN aviation_analysis WHERE TABLE_TYPE LIKE 'VIEW';
CREATE TABLE raw_flights (
    YEAR INT,
    MONTH INT,
    DAY INT,
    DAY_OF_WEEK INT,
    AIRLINE VARCHAR(10),
    FLIGHT_NUMBER INT,
    TAIL_NUMBER VARCHAR(10),
    ORIGIN_AIRPORT VARCHAR(10),
    DESTINATION_AIRPORT VARCHAR(10),
    SCHEDULED_DEPARTURE INT,
    DEPARTURE_TIME INT,
    DEPARTURE_DELAY FLOAT, 
    TAXI_OUT INT,
    WHEELS_OFF INT,
    SCHEDULED_TIME INT,
    ELAPSED_TIME INT,
    AIR_TIME INT,
    DISTANCE INT,
    WHEELS_ON INT,
    TAXI_IN INT,
    SCHEDULED_ARRIVAL INT,
    ARRIVAL_TIME INT,
    ARRIVAL_DELAY FLOAT,    
    DIVERTED INT,
    CANCELLED INT,
    CANCELLATION_REASON VARCHAR(10),
    AIR_SYSTEM_DELAY int,
    SECURITY_DELAY int,
    AIRLINE_DELAY int, 
    LATE_AIRCRAFT_DELAY int,
    WEATHER_DELAY int 
);
select * from raw_flights;
SELECT COUNT(*) FROM raw_flights;

SELECT f.*, a.AIRLINE
FROM cleaned_flight_data_optimized f
LEFT JOIN airlines a ON f.airline = a.IATA_CODE;

SELECT f.*, orig.city as origin_city, orig.state as origin_state,
       dest.city as destination_city, dest.state as destination_state
FROM cleaned_flight_data_optimized f
LEFT JOIN airports orig ON f.ORIGIN_AIRPORT = orig.IATA_CODE
LEFT JOIN airports_dest dest ON f.DESTINATION_AIRPORT = dest.IATA_CODE;

