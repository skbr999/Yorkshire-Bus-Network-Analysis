USE yorkshire_gtfs;
SHOW DATABASES;
CREATE TABLE IF NOT EXISTS agency (
    agency_id VARCHAR(50),
    agency_name VARCHAR(255),
    agency_url VARCHAR(255),
    agency_timezone VARCHAR(100),
    agency_lang VARCHAR(50),
    agency_phone VARCHAR(50),
    agency_noc VARCHAR(50)
);
DESCRIBE agency;
SHOW TABLES;
SELECT * FROM agency;
SELECT COUNT(*) FROM agency;
SELECT * FROM agency LIMIT 10;
CREATE TABLE IF NOT EXISTS routes (
    route_id VARCHAR(50),
    agency_id VARCHAR(50),
    route_short_name VARCHAR(100),
    route_long_name VARCHAR(255),
    route_type INT
);
Describe routes;
Show tables;
Select * From routes;
Select Count(*) From routes;
Select * From routes Limit 20;
CREATE TABLE calendar (
    service_id VARCHAR(50),
    monday INT,
    tuesday INT,
    wednesday INT,
    thursday INT,
    friday INT,
    saturday INT,
    sunday INT,
    start_date VARCHAR(20),
    end_date VARCHAR(20)
);
  SELECT COUNT(*) FROM calendar;
  CREATE TABLE calendar_dates (
    service_id VARCHAR(50),
    service_date VARCHAR(20),
    exception_type INT
);
  SELECT COUNT(*) FROM calendar_dates;
  SELECT * FROM calendar LIMIT 5;
CREATE TABLE trips (
    route_id VARCHAR(50),
    service_id VARCHAR(50),
    trip_id VARCHAR(100),
    trip_headsign VARCHAR(255),
    direction_id INT,
    block_id VARCHAR(100),
    shape_id VARCHAR(100),
    wheelchair_accessible INT,
    vehicle_journey_code VARCHAR(100)
);
SELECT COUNT(*) FROM trips;
SHOW TABLES;
CREATE TABLE stops (
    stop_id VARCHAR(100),
    stop_code VARCHAR(100),
    stop_name VARCHAR(255),
    stop_desc VARCHAR(255),
    stop_lat DECIMAL(10,7),
    stop_lon DECIMAL(10,7),
    zone_id VARCHAR(100),
    stop_url VARCHAR(255),
    location_type INT
);
DESCRIBE stops;
SELECT COUNT(*) FROM stops;
DROP TABLE IF EXISTS stops;
CREATE TABLE stops (
    stop_id VARCHAR(100),
    stop_code VARCHAR(100),
    stop_name VARCHAR(255),
    stop_lat DECIMAL(10,7),
    stop_lon DECIMAL(10,7),
    wheelchair_boarding INT,
    location_type INT,
    parent_station VARCHAR(100),
    platform_code VARCHAR(100)
);
describe stops;
SELECT COUNT(*) FROM stops;
CREATE TABLE shapes (
    shape_id VARCHAR(100),
    shape_pt_lat DECIMAL(10,7),
    shape_pt_lon DECIMAL(10,7),
    shape_pt_sequence INT,
    shape_dist_traveled DECIMAL(10,2)
);
SELECT COUNT(*) FROM shapes;
DROP TABLE IF EXISTS shapes;
CREATE TABLE shapes (
    shape_id VARCHAR(100),
    shape_pt_lat DECIMAL(10,7),
    shape_pt_lon DECIMAL(10,7),
    shape_pt_sequence INT,
    shape_dist_traveled VARCHAR(50)
);
SELECT COUNT(*) FROM shapes;
SELECT * FROM shapes LIMIT 10;
CREATE TABLE feed_info (
    feed_publisher_name VARCHAR(255),
    feed_publisher_url VARCHAR(255),
    feed_lang VARCHAR(50),
    feed_start_date VARCHAR(20),
    feed_end_date VARCHAR(20),
    feed_version VARCHAR(100)
);
SHOW TABLES;
CREATE TABLE stop_times (
    trip_id VARCHAR(100),
    arrival_time VARCHAR(20),
    departure_time VARCHAR(20),
    stop_id VARCHAR(100),
    stop_sequence INT,
    stop_headsign VARCHAR(255),
    pickup_type INT,
    drop_off_type INT,
    shape_dist_traveled VARCHAR(50),
    timepoint INT
);
SELECT COUNT(*) FROM stop_times;
SHOW TABLES;
SELECT 
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS total_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY 
    r.route_short_name,
    r.route_long_name
ORDER BY total_trips DESC
LIMIT 10;
SELECT
    stop_id,
    COUNT(*) AS stop_visits
FROM stop_times
GROUP BY stop_id
ORDER BY stop_visits DESC
LIMIT 10;
SELECT
    s.stop_name,
    COUNT(*) AS stop_visits
FROM stop_times st
JOIN stops s
    ON st.stop_id = s.stop_id
GROUP BY s.stop_name
ORDER BY stop_visits DESC
LIMIT 10;
SELECT
    LEFT(arrival_time, 2) AS hour_of_day,
    COUNT(*) AS total_stop_events
FROM stop_times
GROUP BY hour_of_day
ORDER BY total_stop_events DESC;
SELECT DISTINCT trip_id
FROM stop_times
WHERE LEFT(arrival_time,2) IN ('30','31','32','33');
SELECT
    t.trip_id,
    t.route_id,
    r.route_short_name,
    r.route_long_name
FROM trips t
JOIN routes r
    ON t.route_id = r.route_id
WHERE t.trip_id IN (
    SELECT DISTINCT trip_id
    FROM stop_times
    WHERE LEFT(arrival_time,2) IN ('30','31','32','33')
);
SELECT
    route_id,
    route_short_name,
    route_long_name,
    route_type
FROM routes
WHERE route_short_name IN
('UK001','UKN31','UKN11','UKN02','UKN14','465');
SELECT
    route_type,
    COUNT(*) AS total_routes
FROM routes
GROUP BY route_type
ORDER BY total_routes DESC;
SELECT
    r.route_short_name,
    LEFT(st.arrival_time, 2) AS hour_of_day,
    COUNT(DISTINCT st.trip_id) AS trips_per_hour
FROM stop_times st
JOIN trips t
    ON st.trip_id = t.trip_id
JOIN routes r
    ON t.route_id = r.route_id
GROUP BY
    r.route_short_name,
    hour_of_day
ORDER BY
    trips_per_hour DESC
    limit 20;
    SELECT
    s.stop_name,
    COUNT(DISTINCT t.route_id) AS route_coverage
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
JOIN trips t
    ON st.trip_id = t.trip_id
GROUP BY s.stop_name
ORDER BY route_coverage DESC
LIMIT 20;
SELECT
    r.route_short_name,
    COUNT(DISTINCT st.stop_id) AS total_stops_served
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN stop_times st
    ON t.trip_id = st.trip_id
GROUP BY r.route_short_name
ORDER BY total_stops_served DESC
LIMIT 20;