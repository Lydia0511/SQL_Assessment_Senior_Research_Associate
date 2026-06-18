CREATE DATABASE healthcareAssessment_db;

USE healthcareAssessment_db;
CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(100)
);
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    provider_id INT,
    service_date DATE,
    claim_amount DECIMAL(10,2),
    revenue_received DECIMAL(10,2),

    FOREIGN KEY(provider_id)
    REFERENCES providers(provider_id)
);
INSERT INTO providers VALUES
(1,'John Smith','Cardiology'),
(2,'Mary Johnson','Cardiology'),
(3,'David Brown','Cardiology'),
(4,'Chris Green','Cardiology'),
(5,'Emma White','Cardiology'),
(6,'Peter Black','Cardiology'),
(7,'Sarah Lee','Dermatology'),
(8,'Kevin Roy','Dermatology');
INSERT INTO claims VALUES
(101,1,'2025-01-10',500,450),
(102,1,'2025-02-10',700,650),
(103,2,'2025-03-10',900,850),
(104,3,'2025-04-10',1200,1150),
(105,4,'2025-05-10',800,750),
(106,5,'2025-06-10',950,900),
(107,6,'2025-07-10',600,550),
(108,7,'2025-08-10',400,350),
(109,8,'2025-09-10',500,450);

WITH provider_revenue AS
(
SELECT
      p.provider_name,
      p.specialty,
      COUNT(c.claim_id) AS total_claims,
      SUM(c.revenue_received) AS total_revenue
FROM providers p
JOIN claims c
      ON p.provider_id = c.provider_id
WHERE YEAR(c.service_date)=2025
GROUP BY
      p.provider_name,
      p.specialty
),

ranked_providers AS
(
SELECT *,
       ROW_NUMBER() OVER
       (
           PARTITION BY specialty
           ORDER BY total_revenue DESC
       ) AS rn
FROM provider_revenue
)

SELECT
       provider_name,
       specialty,
       total_claims,
       total_revenue
FROM ranked_providers
WHERE rn <= 5
ORDER BY specialty,total_revenue DESC;