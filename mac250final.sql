/* Create the database system */
gcloud sql instances create mac250-final \
--database-version MYSQL_8_0 \
--root-password 'P@$$w0rd' \
--authorized-networks 100.12.185.0/24 \
--storage-type SSD \
--storage-size 10GB \
--tier=db-n1-standard-1 \
--region=us-east1

/*Use the CURL command in cloudshell 
to obtain the ip address of the cloudshell */
curl ipecho.net

/* connect to sql*/
mysql \
--user=root \
--host=34.139.221.240 \
--ssl-ca=server-ca.pem \
--ssl-cert=client-cert.pem \
--ssl-key=client-key.pem \
--password \
--local-infile=1

/* SSL connection*/
mysql -uroot -p -h 34.139.221.240 --ssl-ca=server-ca.pem --ssl-cert=client-cert.pem --ssl-key=client-key.pem
P@$$w0rd

/* Create the schema and tables*/
CREATE DATABASE mac250final;
USE mac250final;
CREATE TABLE destination (
    Id int(255),
    Destination varchar(255),
    International_tourist_arrivals_in_2019 varchar(255),
    International_tourist_arrivals_in_2018 varchar(255),
    Region varchar(255)
);

/*Import the data from a comma separated values file (csv)*/
LOAD DATA LOCAL INFILE './mac250.csv' 
INTO TABLE mac250final.destination 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;




/*creating stored PROCEDURE*/ 
DELIMITER //
CREATE PROCEDURE sumoftourist2019()
BEGIN
select SUM(International_tourist_arrivals_in_2019)
from destination;
END//

call sumoftourist2019();

DELIMITER //
CREATE PROCEDURE sumoftourist2018()
BEGIN
select SUM(International_tourist_arrivals_in_2018)
from destination;
END//

call sumoftourist2018();

/*creating views*/

create view americantouristsum2019 as 
select SUM(International_tourist_arrivals_in_2019)
from destination
where region = "America";

select * from americantouristsum2019;


create view americantouristsum2018 as 
select SUM(International_tourist_arrivals_in_2018)
from destination
where region = "America";

select * from americantouristsum2018;


create view min as 
select MIN(International_tourist_arrivals_in_2019)
from destination;

select * from min;

create view max as 
select MAX(International_tourist_arrivals_in_2019)
from destination;

select * from max; 


/* random queries*/

/* average tourist for 2019 grouped by region*/
select Region, AVG(cast(replace(International_tourist_arrivals_in_2019,'million', '')as 
decimal(10, 2))) as avgArrivals2019 from destination group by Region; 

/* top 5 tourist destination for 2018 and 2019*/
select Destination, International_tourist_arrivals_in_2018 from destination 
order by cast(replace(International_tourist_arrivals_in_2018, 'million', '')as decimal(10,2)) desc limit 5; 

select Destination, International_tourist_arrivals_in_2019 from destination 
order by cast(replace(International_tourist_arrivals_in_2019, 'million', '')as decimal(10,2)) desc limit 5;



/* creating backup */
mysqldump -u root -h 34.139.221.240 --set-gtid-purged=OFF --single-transaction --triggers --routines --events -p mac250final > group3.sql
P@$$w0rd

/*Mysql Restore DB */
mysql -u root -p -h 34.139.221.240  mac250final < group3.sql

/* metabase codes*/ 

ELena's part

1. creating VM

gcloud compute instances create metabase \
--image-family ubuntu-2204-lts \
--image-project ubuntu-os-cloud \
--machine-type n1-standard-1 \
--description metabase \
--zone us-east1-b \
--metadata=startup-script='#! /bin/bash apt update -y
apt install openjdk-16-jre-headless -y
cd /opt
curl -L https://downloads.metabase.com/v0.46.4/metabase.jar -o metabase.jar'

2. connect ssh 
ssh elena_chagaeva@34.75.219.124

3. download metabase 
apt update -y
apt install openjdk-16-jre-headless -y
cd /opt
curl -L https://downloads.metabase.com/v0.46.4/metabase.jar -o metabase.jar
sudo apt install openjdk-11-jre-headless (because it says after running next comman that Command 'java' not found, but can be installed with:...)
java -jar metabase.jar

4. 
http://34.75.219.124:3000/setup

5. Creating firewall
gcloud compute \
--project="crafty-sound-403802" firewall-rules create default-allow-metabase \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:3000 \
--source-ranges="104.162.183.77,146.111.34.171,146.111.144.172,146.111.144.140" \
--target-tags=allow-metabase

6. (not nessasary if make it mannualy)
gcloud compute instances add-tags metabase \
--zone us-east1-b \
--tags allow-metabase



Most_Visited_Destination_in_2018_and_2019.csv

queries

1. The sum of international tourist arrivals in 2019 for each region

SELECT Region, SUM(CAST(REPLACE(International_tourist_arrivals_in_2019, ' million', '') AS DECIMAL(10, 2))) AS SumArrivals2019
FROM destination
GROUP BY Region;

2. Top 10 Destinations in 2019

SELECT Destination,
CAST(SUM(REPLACE(International_tourist_arrivals_in_2019, ' million', '')) AS DECIMAL(10, 2)) AS TotalArrivalsIn2019
FROM destination
GROUP BY Destination
ORDER BY TotalArrivalsIn2019 DESC
LIMIT 10;

3. Top 10 Destinations in 2018

SELECT Destination,
CAST(SUM(REPLACE(International_tourist_arrivals_in_2018, ' million', '')) AS DECIMAL(10, 2)) AS TotalArrivalsIn2018
FROM destination
GROUP BY Destination
ORDER BY TotalArrivalsIn2018 DESC
LIMIT 10;

4. List the destinations with a decrease in visits from 2018 to 2019:

SELECT Destination,
CAST(REPLACE(International_tourist_arrivals_in_2018, ' million', '') AS DECIMAL(10, 2)) AS Tourist2018,
CAST(REPLACE(International_tourist_arrivals_in_2019, ' million', '') AS DECIMAL(10, 2)) AS Tourist2019
FROM destination
WHERE
CAST(REPLACE(International_tourist_arrivals_in_2019, ' million', '') AS DECIMAL(10, 2)) < 
CAST(REPLACE(International_tourist_arrivals_in_2018, ' million', '') AS DECIMAL(10, 2));

5. the total number of visitors in America in 2018 and 2019:

SELECT
Destination,
SUM(CAST(REPLACE(International_tourist_arrivals_in_2018, ' million', '') AS DECIMAL(10, 2))) AS TotalVisits2018,
SUM(CAST(REPLACE(International_tourist_arrivals_in_2019, ' million', '') AS DECIMAL(10, 2))) AS TotalVisits2019
FROM
destination
WHERE
Region = 'America'
GROUP BY Destination;

6. Countries with Min amount of tourists in 2019
SELECT Destination,
CAST(SUM(REPLACE(International_tourist_arrivals_in_2019, ' million', '')) AS DECIMAL(10, 2)) AS TotalArrivalsIn2019
FROM destination
GROUP BY Destination
ORDER BY TotalArrivalsIn2019 ASC
LIMIT 10;

7. Comparison of 2018 vs 2019 by regions
SELECT Region,
SUM(CAST(REPLACE(International_tourist_arrivals_in_2018, ' million', '') AS DECIMAL(10, 2))) AS TotalArrivals2018,
SUM(CAST(REPLACE(International_tourist_arrivals_in_2019, ' million', '') AS DECIMAL(10, 2))) AS TotalArrivals2019
FROM destination
GROUP BY Region;