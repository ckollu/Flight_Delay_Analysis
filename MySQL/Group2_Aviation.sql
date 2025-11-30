
CREATE VIEW cleaned_flight_data_optimized AS
WITH base_data AS (
    SELECT 
        YEAR,
        MONTH,
        DAY,
        DAY_OF_WEEK,
        AIRLINE,
        FLIGHT_NUMBER,
        TAIL_NUMBER,
        ORIGIN_AIRPORT,
        DESTINATION_AIRPORT,
        SCHEDULED_DEPARTURE,
        DEPARTURE_TIME,
        DEPARTURE_DELAY,
        TAXI_OUT,
        WHEELS_OFF,
        SCHEDULED_TIME,
        ELAPSED_TIME,
        AIR_TIME,
        DISTANCE,
        WHEELS_ON,
        TAXI_IN,
        SCHEDULED_ARRIVAL,
        ARRIVAL_TIME,
        ARRIVAL_DELAY,
        DIVERTED,
        CANCELLED,
        CANCELLATION_REASON,
        AIR_SYSTEM_DELAY,
        SECURITY_DELAY,
        AIRLINE_DELAY,
        LATE_AIRCRAFT_DELAY,
        WEATHER_DELAY
    FROM raw_flights
),


handled_nulls AS (
    SELECT 
        YEAR,
        MONTH,
        DAY,
        DAY_OF_WEEK,
        AIRLINE,
        FLIGHT_NUMBER,
        TAIL_NUMBER,
        ORIGIN_AIRPORT,
        DESTINATION_AIRPORT,
        DISTANCE,
        DIVERTED,
        CANCELLED,
        CANCELLATION_REASON,
        
        # Cleaned delay columns (replace nulls with 0)
        COALESCE(DEPARTURE_DELAY, 0) as departure_delay,
        COALESCE(ARRIVAL_DELAY, 0) as arrival_delay,
        COALESCE(AIR_SYSTEM_DELAY, 0) as air_system_delay,
        COALESCE(SECURITY_DELAY, 0) as security_delay,
        COALESCE(AIRLINE_DELAY, 0) as airline_delay,
        COALESCE(LATE_AIRCRAFT_DELAY, 0) as late_aircraft_delay,
        COALESCE(WEATHER_DELAY, 0) as weather_delay,
        
        # Cleaned time columns
        SCHEDULED_DEPARTURE,
        DEPARTURE_TIME,
        WHEELS_OFF,
        WHEELS_ON,
        SCHEDULED_ARRIVAL,
        ARRIVAL_TIME,
        COALESCE(TAXI_OUT, 0) as taxi_out,
        COALESCE(TAXI_IN, 0) as taxi_in,
        
	
        SCHEDULED_TIME,
        ELAPSED_TIME,
        AIR_TIME
    FROM base_data
),


filtered_data AS (
    SELECT *
    FROM handled_nulls
    WHERE 
        LENGTH(ORIGIN_AIRPORT) = 3 
        AND LENGTH(DESTINATION_AIRPORT) = 3
        AND ORIGIN_AIRPORT IS NOT NULL 
        AND DESTINATION_AIRPORT IS NOT NULL
        AND ORIGIN_AIRPORT != '' 
        AND DESTINATION_AIRPORT != ''
        AND departure_delay BETWEEN -120 AND 1440
        AND arrival_delay BETWEEN -120 AND 1440
        AND TAIL_NUMBER IS NOT NULL 
        AND TAIL_NUMBER != ''
),

# Convert times and create calculated columns
final_data AS (
    SELECT 
      
        AIRLINE,
        FLIGHT_NUMBER,
        TAIL_NUMBER,
        ORIGIN_AIRPORT,
        DESTINATION_AIRPORT,
        
       
        YEAR,
        MONTH,
        DAY,
        DAY_OF_WEEK,
        
       
        departure_delay,
        arrival_delay,
        air_system_delay,
        security_delay,
        airline_delay,
        late_aircraft_delay,
        weather_delay,
        
     
        TIME_FORMAT(SEC_TO_TIME((SCHEDULED_DEPARTURE DIV 100) * 3600 + (SCHEDULED_DEPARTURE % 100) * 60), '%H:%i:%s') as scheduled_departure,
        CASE 
            WHEN DEPARTURE_TIME IS NOT NULL THEN 
                TIME_FORMAT(SEC_TO_TIME((DEPARTURE_TIME DIV 100) * 3600 + (DEPARTURE_TIME % 100) * 60), '%H:%i:%s')
            ELSE '00:00:00'
        END as departure_time,
        CASE 
            WHEN WHEELS_OFF IS NOT NULL THEN 
                TIME_FORMAT(SEC_TO_TIME((WHEELS_OFF DIV 100) * 3600 + (WHEELS_OFF % 100) * 60), '%H:%i:%s')
            ELSE '00:00:00'
        END as wheels_off,
        CASE 
            WHEN WHEELS_ON IS NOT NULL THEN 
                TIME_FORMAT(SEC_TO_TIME((WHEELS_ON DIV 100) * 3600 + (WHEELS_ON % 100) * 60), '%H:%i:%s')
            ELSE '00:00:00'
        END as wheels_on,
        TIME_FORMAT(SEC_TO_TIME((SCHEDULED_ARRIVAL DIV 100) * 3600 + (SCHEDULED_ARRIVAL % 100) * 60), '%H:%i:%s') as scheduled_arrival,
        CASE 
            WHEN ARRIVAL_TIME IS NOT NULL THEN 
                TIME_FORMAT(SEC_TO_TIME((ARRIVAL_TIME DIV 100) * 3600 + (ARRIVAL_TIME % 100) * 60), '%H:%i:%s')
            ELSE '00:00:00'
        END as arrival_time,
        
     
        taxi_out,
        taxi_in,
        SCHEDULED_TIME,
        ELAPSED_TIME,
        AIR_TIME,
        DISTANCE,
        DIVERTED,
        CANCELLED,
        CANCELLATION_REASON,
        
      
        STR_TO_DATE(CONCAT(YEAR, '-', MONTH, '-', DAY), '%Y-%m-%d') as flight_date,
        
        CASE 
            WHEN DAY_OF_WEEK BETWEEN 1 AND 5 THEN 'Weekday'
            ELSE 'Weekend'
        END as day_type,
        
        CASE 
            WHEN departure_delay <= 0 AND arrival_delay <= 0 THEN 'No Delay'
            WHEN departure_delay > 15 OR arrival_delay > 15 THEN 'Significant Delay'
            ELSE 'Minor Delay'
        END as delay_category,
        
        CASE 
            WHEN DISTANCE < 500 THEN 'Short (<500)'
            WHEN DISTANCE < 1000 THEN 'Medium (500-1000)'
            WHEN DISTANCE < 2000 THEN 'Long (1000-2000)'
            ELSE 'Very Long (2000+)'
        END as distance_category,
        
        CASE 
            WHEN DISTANCE BETWEEN 2500 AND 3000 THEN '2500-3000 miles'
            ELSE 'Other'
        END as is_long_haul_2500_3000,
        
        CONCAT(YEAR, '-', LPAD(MONTH, 2, '0')) as month_year,
        
        CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(YEAR, '-', MONTH, '-', DAY), '%Y-%m-%d'))) as quarter,
        
       
        CASE 
            WHEN departure_delay > 0 THEN departure_delay
            ELSE 0 
        END as departure_delay_minutes,
        
        CASE 
            WHEN arrival_delay > 0 THEN arrival_delay
            ELSE 0 
        END as arrival_delay_minutes,
        
        CASE WHEN departure_delay > 15 THEN 1 ELSE 0 END as is_departure_delayed,
        CASE WHEN arrival_delay > 15 THEN 1 ELSE 0 END as is_arrival_delayed
        
    FROM filtered_data
)

SELECT * FROM final_data;

SELECT COUNT(*)
FROM cleaned_flight_data_optimized;
select * from cleaned_flight_data_optimized;
