--Find the number of vehicles stolen each year
SELECT YEAR(date_stolen) AS Year, COUNT(DISTINCT vehicle_id) AS Number_of_stolen_vehicle
FROM stolen_vehicles
GROUP BY 1;

--Find the number of vehicles stolen each Month
SELECT MONTH(date_stolen) AS Month, COUNT(DISTINCT vehicle_id) AS Number_of_stolen_vehicle
FROM stolen_vehicles
GROUP BY 1
ORDER BY 1 ASC;

--Find the number of vehicles stolen each day of the week
SELECT DAYOFWEEK(date_stolen) AS Day_of_week, COUNT(DISTINCT vehicle_id) AS Number_of_stolen_vehicle
FROM stolen_vehicles
GROUP BY 1
ORDER BY 1 ASC;

---Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
SELECT 
CASE 
    WHEN DAYOFWEEK(date_stolen)=1 THEN 'Sunday'
    WHEN DAYOFWEEK(date_stolen)=2 THEN 'Monday'
    WHEN DAYOFWEEK(date_stolen)=3 THEN 'Tuesday'
    WHEN DAYOFWEEK(date_stolen)=4 THEN 'Wednesday'
    WHEN DAYOFWEEK(date_stolen)=5 THEN 'Thursday'
    WHEN DAYOFWEEK(date_stolen)=6 THEN 'Friday'
    WHEN DAYOFWEEK(date_stolen)=7 THEN 'Saturday'
END AS DAY_OF_WEEK,
COUNT(DISTINCT vehicle_id) AS Number_of_stolen_vehicle
FROM stolen_vehicles
GROUP BY DAY_OF_WEEK
ORDER BY MIN(DAYOFWEEK(date_stolen));

	--Find the vehicle types that are most often and least often stolen
	SELECT 
  (SELECT vehicle_type FROM (SELECT vehicle_type, COUNT(*) AS count FROM stolen_vehicles GROUP BY vehicle_type) AS counts ORDER BY count ASC LIMIT 1) AS `Minimum Stolen Vehicle Type`,
  (SELECT MIN(count) FROM (SELECT vehicle_type, COUNT(*) AS count FROM stolen_vehicles GROUP BY vehicle_type) AS counts) AS `Number of Stolen`,
  (SELECT vehicle_type FROM (SELECT vehicle_type, COUNT(*) AS count FROM stolen_vehicles GROUP BY vehicle_type) AS counts ORDER BY count DESC LIMIT 1) AS `Maximum Stolen Vehicle Type`,
  (SELECT MAX(count) FROM (SELECT vehicle_type, COUNT(*) AS count FROM stolen_vehicles GROUP BY vehicle_type) AS counts) AS `Number of Stolen`;

--For each vehicle type, find the average age of the cars that are stolen
SELECT vehicle_type, ROUND(AVG(YEAR(date_stolen)-model_year),2) AS `Avg age of stolen car`
FROM stolen_vehicles
GROUP BY 1
ORDER BY 2 DESC;

--For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
WITH LUX_STAND AS (SELECT s.vehicle_type,
	CASE WHEN m.make_type='luxury' THEN 1 ELSE 0 END AS Luxury, 1 AS ALL_vehicle
FROM stolen_vehicles s
LEFT JOIN make_details m
ON s.make_id=m.make_id)
SELECT vehicle_type, ROUND(SUM(Luxury)/SUM(All_vehicle)*100,2) AS Pct_luxury
FROM LUX_STAND
WHERE vehicle_type IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

--	Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen.
SELECT  vehicle_type, COUNT(vehicle_id) as NUM_Vehicle,
	SUM(CASE WHEN color= 'Silver' THEN 1 ELSE 0 END) AS Silver,
	SUM(CASE WHEN color= 'White' THEN 1 ELSE 0 END) AS White,
    SUM(CASE WHEN color= 'Black' THEN 1 ELSE 0 END) AS Black,
    SUM(CASE WHEN color= 'Blue' THEN 1 ELSE 0 END) AS Blue,
	SUM(CASE WHEN color= 'Red' THEN 1 ELSE 0 END) AS Red,
    SUM(CASE WHEN color= 'Grey' THEN 1 ELSE 0 END) AS Grey,
    SUM(CASE WHEN color= 'Green' THEN 1 ELSE 0 END) AS Green,
    SUM(CASE WHEN color IN ('Gold','Brown','Yellow','Orange','Purple','Cream','Pink') THEN 1 ELSE 0 END) AS Other
FROM stolen_vehicles
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10; 
