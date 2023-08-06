-- Create a database called 'foodie_fi'
create database foodie_fi;

-- Creating and populating the 'plans' table
CREATE TABLE plans (
    plan_id INT,                                     -- Column for the plan's unique identifier
    plan_name VARCHAR(20),                           -- Column for the name of the plan (limited to 20 characters)
    price TEXT                                       -- Column for the price of the plan (stored as text to accommodate various formats)
);

-- Inserting data into the 'plans' table
insert into plans(plan_id,plan_name,price)
   values("0","trial","0"),                          -- A trial plan with ID 0 and a price of 0
   ("1","basic monthly","9.90"),                     -- A basic monthly plan with ID 1 and a price of 9.90
   ("2","pro monthly","19.90"),                      -- A pro monthly plan with ID 2 and a price of 19.90
   ("3","pro annual","199"),                         -- A pro annual plan with ID 3 and a price of 199
   ("4","churn","");                                 -- A churn plan with ID 4 and an empty price (indicating that it's when a customer cancels a plan)

-- Create a new table named 'subscriptions' with the specified columns
SELECT 
    *
FROM
    plans;
 CREATE TABLE subscriptions (
    customer_id INT,
    plan_id INT,
    start_date DATE
);

-- Insert data into the 'subscriptions' table
-- Each row represents a customer's subscription to a plan with a specific start date
insert into subscriptions(customer_id,plan_id,start_date)
   values("1","0","2020-08-01"),
   ("1","1","2020-08-08"),
   ("2","0","2020-09-20"),
   ("2","3","2020-09-27"),
   ("11","0","2020-11-19"),
   ("11","4","2020-11-26"),
   ("13","0","2020-12-15"),
   ("13","1","2020-12-22"),
   ("13","2","2021-03-29"),
   ("15","0","2020-03-17"),
   ("15","2","2020-03-24"),
   ("15","4","2020-04-29"),
   ("16","0","2020-05-31"),
   ("16","1","2020-06-07"),
   ("16","3","2020-10-21"),
   ("18","0","2020-07-06"),
   ("18","2","2020-07-13"),
   ("19","0","2020-06-22"),
   ("19","2","2020-06-29"),
   ("19","3","2020-08-29");
   

   -- A.Customer Journey
   
   -- This SQL query retrieves information about customer subscriptions and their corresponding plans.
SELECT 
    customer_id,s.plan_id, plan_name, start_date
FROM
    subscriptions s
        INNER JOIN
    plans p ON s.plan_id = p.plan_id
GROUP BY customer_id,s.plan_id
ORDER BY customer_id,s.plan_id;
 --  description of each customer's onboarding journey with the aid of the above join 
 /* -customer no.1 started with the free trail and at the end of it downgraded to baisc monthly plan 
    -customer no.2  started with the free trail and at the end of it upgraded to pro annual
    -customer no.11 started with a free trail and when it ended they cancelled their service
    -customer no.13 started with a free trail and at the end of it downgraded to basic monthly and 7 days later upgraded to pro monthly
    -customer no.15 started with a free trail and then at the end of it let continue to pro monthly but then cancelled their service  5 days later
    -customer no.16 started with  a free tail and when it ended they downgraded to basic monthly then upgraded to pro annual a few monthls later
    -customer no.18 started with a free trail and when it ended they let it automatically continue to pro monthly
    -customer no.19 started with a free trail and when it ended they let automatically continue to pro monthly then a few months later upgraded to pro annual*/ 
    
 -- Data Analysis 

-- This SQL query calculates the number of distinct customers from the 'subscriptions' table.
SELECT 
    COUNT(DISTINCT (customer_id)) as number_of_customers            -- The COUNT() function is used to count the number of distinct customer_ids in the 'subscriptions' table.
																	-- The DISTINCT keyword ensures that duplicate customer_ids are not counted multiple times.
FROM
    subscriptions;
--  Foodie-Fi has had 8 customers

-- This SQL query shows monthly distribution of trial plan start_date values for dataset and breakdown by counts of events  value
SELECT 
    MONTHNAME(start_date) as month, COUNT(customer_id), plan_name
FROM
    subscriptions s
        JOIN
    plans p ON s.plan_id = p.plan_id
WHERE
    plan_name = 'trial'
GROUP BY month;
-- All the months have 1 trial plan customer


-- This SQL query retrieves the count of subscriptions for each unique plan_name from the 'subscriptions' table
-- for plans that have a 'start_date' that occur after the year 2020.
SELECT 
    s.plan_id, COUNT(plan_name), plan_name, start_date
FROM
    subscriptions s
        INNER JOIN
    plans p ON s.plan_id = p.plan_id
WHERE
    YEAR(start_date) > 2020
GROUP BY plan_name;
-- only pro monthly has a plan that started after 2021

-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
-- Creating a temporary table count_cte to store the result of the following query:
-- This CTE (Common Table Expression) will count the number of customer churns and the total number of unique customers in the subscriptions table.
CREATE TABLE count_cte AS (SELECT COUNT(CASE
        WHEN plan_id = 4 THEN 1
    END) AS customer_churn,                                    -- Count the number of churned customers (plan_id = 4).
    COUNT(DISTINCT customer_id) AS no_of_customers FROM        -- Count the total number of unique customers in the subscriptions table.
    subscriptions)
;

-- This is the final query to calculate the churn percentage and present the result.
-- It retrieves the values of customer_churn and no_of_customers from the count_cte temporary table and calculates the churn percentage.
SELECT 
    ROUND((customer_churn / no_of_customers) * 100,
            1) as churn_percentage                         -- Calculate churn percentage by dividing customer_churn by no_of_customers and multiplying by 100. It is rounded to one decimal place.
FROM
    count_cte;
 -- 25.0%(2 customers) of the total of 8 customers have churned


  
  
  
  
  
  
  
   
   






















