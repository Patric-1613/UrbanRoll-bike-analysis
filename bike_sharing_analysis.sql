
SELECT * FROM `teak-mix-343220.Sequal_practise_dataset.rider` LIMIT 1000;
SELECT * FROM `teak-mix-343220.Sequal_practise_dataset.stations` LIMIT 1000;
SELECT * FROM `teak-mix-343220.Sequal_practise_dataset.users` LIMIT 1000;

-- Checking the count of entries in each table
SELECT 

  (SELECT COUNT(*) FROM `teak-mix-343220.Sequal_practise_dataset.rider` ),
  (SELECT COUNT(*) FROM `teak-mix-343220.Sequal_practise_dataset.stations` ),
  (SELECT COUNT(*) FROM `teak-mix-343220.Sequal_practise_dataset.users` );


-- Checking for the NULL values

SELECT 
  COUNTIF(ride_id IS NULL) AS null_ride_ids ,
  COUNTIF(user_id IS NULL) AS null_user_ids ,
  COUNTIF(distance_km IS NULL) AS null_distance

  FROM `teak-mix-343220.Sequal_practise_dataset.rider` ;

--- Summary statistics for the rider table 

SELECT  

  MIN(distance_km) AS min_distance,
  MAX(distance_km) AS max_distance,
  AVG(distance_km) AS avg_distance,
  MIN(TIMESTAMP_DIFF(end_time, start_time, MINUTE)) AS min_travel_time,
  MAX(TIMESTAMP_DIFF(end_time, start_time, MINUTE)) AS max_travel_time,
  AVG(TIMESTAMP_DIFF(end_time, start_time, MINUTE)) AS avg_travel_time


FROM `teak-mix-343220.Sequal_practise_dataset.rider`;

-- checking for the false starts 

SELECT 

  COUNTIF(TIMESTAMP_DIFF(end_time, start_time, MINUTE)< 2) AS short_duration_trips ,
  COUNTIF(distance_km = 0) AS short_distances

FROM `teak-mix-343220.Sequal_practise_dataset.rider`;

--- Differnt membership 

SELECT 
  u.membership_level AS membership,
  AVG(TIMESTAMP_DIFF(r.end_time, r.start_time, MINUTE)) AS avg_travelling_time,
  COUNT(r.ride_id) AS riders_count,
  AVG(r.distance_km) AS avg_distance_travelled


FROM `teak-mix-343220.Sequal_practise_dataset.rider` AS r 
  JOIN `teak-mix-343220.Sequal_practise_dataset.users` AS u
  ON r.user_id = u.user_id
GROUP BY u.membership_level
ORDER BY COUNT(r.ride_id) DESC;

--- Peek hours  

SELECT 

  EXTRACT( HOUR FROM start_time) AS hour_of_day,
  COUNT (*) AS ride_count

 FROM `teak-mix-343220.Sequal_practise_dataset.rider`

  GROUP BY 1
  ORDER BY 2 DESC;

--check for the popular stations

SELECT 
 
  s.station_name,
  COUNT(r.ride_id) AS total_riders

  FROM `teak-mix-343220.Sequal_practise_dataset.rider` AS r 
  JOIN `teak-mix-343220.Sequal_practise_dataset.stations` AS s
    ON r.start_station_id = s.station_id
  GROUP BY s.station_name
  ORDER BY COUNT(r.ride_id) DESC;


--- Categorising rides into Long, short and medium 

SELECT 
  CASE 
    WHEN TIMESTAMP_DIFF(end_time, start_time, MINUTE) <=10 THEN 'short_trip'
    WHEN TIMESTAMP_DIFF(end_time, start_time, MINUTE) BETWEEN 11 AND 30 THEN 'medium_trip'
    ELSE  'long_trip'
  END AS ride_category,
  COUNT(*) count_of_rides
  FROM `teak-mix-343220.Sequal_practise_dataset.rider`
  GROUP BY ride_category
  ORDER BY count_of_rides DESC;

-- Net flow for each station 

WITH departures AS (
  SELECT start_station_id, COUNT(*) total_departures
   FROM `teak-mix-343220.Sequal_practise_dataset.rider`
   GROUP BY 1
),

ariavals AS (
  SELECT end_station_id, COUNT(*) total_arriavals
  FROM `teak-mix-343220.Sequal_practise_dataset.rider`
  GROUP BY 1

)

SELECT 
  s.station_name,
  d.total_departures,
  a.total_arriavals,
  (a.total_arriavals-d.total_departures) AS net_flow

FROM  `teak-mix-343220.Sequal_practise_dataset.stations` AS s 
JOIN departures AS d ON s.station_id= d.start_station_id
JOIN ariavals AS a ON s.station_id= a.end_station_id

ORDER BY net_flow ASC;

--- User retention

WITH monthly_signups AS (
SELECT
  EXTRACT(MONTH FROM created_at) AS signup_month,
  COUNT(user_id) AS new_user_count,
FROM `teak-mix-343220.Sequal_practise_dataset.users`
GROUP BY signup_month
)

SELECT 
  signup_month,
  new_user_count,
  LAG(new_user_count) OVER (ORDER BY signup_month) AS previous_month_count,
  (new_user_count - LAG(new_user_count) OVER (ORDER BY signup_month))/ 
  NULLIF(LAG(new_user_count) OVER (ORDER BY signup_month) ,0) *100 AS month_over_month_growth
FROM monthly_signups
ORDER BY signup_month; 

onth
