create database commercial_real_estate;
use commercial_real_estate;

CREATE TABLE commercial_data (
    price_index DECIMAL(18, 8),
    property_type VARCHAR(100),
    weight DECIMAL(10, 6),
    quarter_key INT,
    year_key INT,
    quarterly_change DECIMAL(18, 10),
    annual_change DECIMAL(18, 10)
);

SELECT 
    year_key, 
    property_type, 
    annual_change,
    RANK() OVER (PARTITION BY year_key ORDER BY annual_change DESC) as performance_rank
FROM commercial_data;

SELECT 
        year_key, 
        quarter_key, 
        price_index,
        (SELECT AVG(price_index) FROM commercial_data) as historical_avg,
        CASE 
            WHEN price_index > (SELECT AVG(price_index) FROM commercial_data) THEN 'Above Average'
            ELSE 'Below Average'
        END as market_standing
    FROM commercial_data;
    
CREATE VIEW market_summary_latest AS
SELECT 
    property_type, 
    ROUND(AVG(price_index), 2) AS avg_price,
    ROUND(SUM(weight), 4) AS total_weight,
    ROUND(AVG(annual_change), 4) AS avg_annual_growth
FROM commercial_data
GROUP BY property_type;

SELECT 
    year_key, 
    property_type, 
    AVG(annual_change) AS avg_annual_growth,
    RANK() OVER (PARTITION BY year_key ORDER BY AVG(annual_change) DESC) as sector_rank
FROM commercial_data
GROUP BY year_key, property_type;

