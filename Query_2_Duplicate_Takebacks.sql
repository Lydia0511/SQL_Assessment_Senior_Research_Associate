CREATE TABLE claim_transactions
(
transaction_id INT PRIMARY KEY,
claim_id VARCHAR(50),
transfer_type VARCHAR(50),
insurance_package VARCHAR(100),
insurance_reporting_category VARCHAR(100),
procedure_code VARCHAR(50),
takeback_amount DECIMAL(10,2),
payment_amount DECIMAL(10,2),
claim_status VARCHAR(50),
claim_outstanding DECIMAL(10,2),
charge_outstanding DECIMAL(10,2),
payment_batch_details VARCHAR(100)
);
INSERT INTO claim_transactions VALUES
(
1,
'3961760V1632',
'Informational Takeback',
'Medicare',
'Government',
'99213',
100,
500,
'Open',
100,
100,
'Batch001'
),

(
2,
'3961760V1632',
'True Takeback',
'Medicare',
'Government',
'99213',
100,
500,
'Open',
100,
100,
'Batch002'
),

(
3,
'3961760V1632',
'Payment',
'Medicare',
'Government',
'99213',
0,
500,
'Open',
100,
100,
'Batch003'
);

SELECT
       claim_id,
       transfer_type,
       insurance_package,
       insurance_reporting_category,
       procedure_code,
       takeback_amount,
       payment_amount,
       claim_status,
       claim_outstanding,
       charge_outstanding,
       payment_batch_details
FROM claim_transactions ct
WHERE claim_status='Open'
AND EXISTS
(
      SELECT 1
      FROM claim_transactions ct2
      WHERE ct.claim_id = ct2.claim_id
      AND ct.takeback_amount = ct2.takeback_amount
      AND ct.transfer_type <> ct2.transfer_type
      AND ct.transfer_type IN
      (
          'Informational Takeback',
          'True Takeback'
      )
      AND ct2.transfer_type IN
      (
          'Informational Takeback',
          'True Takeback'
      )
);