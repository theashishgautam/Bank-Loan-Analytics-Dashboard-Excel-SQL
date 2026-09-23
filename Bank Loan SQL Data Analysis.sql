CREATE DATABASE Bank_Loan;

SELECT * FROM financial_loan;

--------- Bank Loan Report | Summary ---------

# 1.
--    Total Loan Applications
select Count(id) AS Total_Loan_Application from financial_loan;

--    MTD Loan Applications
SELECT COUNT(id) AS MTD_Total_Application FROM financial_loan
WHERE MONTH(issue_date) = 12;

--    PMTD Loan Applications
SELECT COUNT(id) AS PMTD_Total_Application FROM financial_loan
WHERE MONTH(issue_date) = 11;

SELECT COUNT(id) AS Total_Loan_Applications,
         SUM(CASE
                 WHEN MONTH(issue_date) = 12
				 THEN 1
				 ELSE 0
				 END) AS MTD_Loan_Applications,
		 SUM(CASE
				 WHEN MONTH(issue_date) = 11
				 THEN 1
				 ELSE 0
				 END) AS PMTD_Loan_Applications
FROM financial_loan;


# 2.
--    Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM financial_loan;

--    MTD Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM financial_loan
WHERE MONTH(issue_date) = 12;

--    PMTD Total Funded Amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM financial_loan
WHERE MONTH(issue_date) = 11;

SELECT SUM(loan_amount) AS Total_Funded_Amount,
       SUM(CASE
               WHEN MONTH(issue_date) = 12
               THEN loan_amount
               ELSE 0
               END) AS MTD_Total_Funded_Amount,
	   SUM(CASE
               WHEN MONTH(issue_date) = 11
               THEN loan_amount
               ELSE 0
               END) AS PMTD_Total_Funded_Amount
FROM financial_loan;


# 3.	
--    Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Received FROM financial_loan;

--    MTD Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date) = 12;

--    PMTD Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date) = 11;

SELECT SUM(total_payment) AS Total_Amount_Received,
       SUM(CASE
               WHEN MONTH(issue_date) = 12
               THEN total_payment
               ELSE 0
               END) AS MTD_Total_Amount_Received,
	   SUM(CASE
               WHEN MONTH(issue_date) = 11
               THEN total_payment
               ELSE 0
               END) AS PMTD_Total_Amount_Received
FROM financial_loan;


# 4.
--    Average Interest Rate
SELECT ROUND(AVG(int_rate) * 100,2) AS Avg_Interest_Rate,
	   ROUND(AVG(CASE
                     WHEN MONTH(issue_date) = 12
                     THEN int_rate
                     ELSE 0
                     END) * 100,2) AS MTD_Avg_Interest_Rate,
	   ROUND(AVG(CASE
                     WHEN MONTH(issue_date) = 11
                     THEN int_rate
                     ELSE 0
                     END) * 100,2) AS PMTD_Avg_Interest_Rate
FROM financial_loan;


# 5.
--    Average Debt-to-Income Ratio(DTI)
SELECT ROUND(AVG(dti) * 100,2) AS Avg_DTI,
       ROUND(AVG(CASE
                     WHEN MONTH(issue_date) = 12
                     THEN dti
                     ELSE 0
                     END) * 100,2) AS MTD_Avg_DTI,
       ROUND(AVG(CASE
                     WHEN MONTH(issue_date) = 11
                     THEN dti
                     ELSE 0
                     END) * 100,2) AS PMTD_Avg_DTI
FROM financial_loan;



# 6.
--    Good Loan Application Percentage
SELECT COUNT(CASE
                 WHEN loan_status = 'Fully Paid'
	 	 		   OR loan_status = 'Current'
				 THEN id
                 END) * 100
                 /
	   COUNT(id) AS Good_loan_Percentage
FROM financial_loan;


# 7. 
--    Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM financial_loan
WHERE loan_status = 'Fully Paid'
   OR loan_status = 'Current';


# 8.
--    Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded FROM financial_loan
WHERE loan_status = 'Fully Paid'
   OR loan_status = 'Current';


# 9. 
--    Good Loan Total Received Amount
SELECT * FROM financial_loan;

SELECT SUM(total_payment) AS Good_Loan_Received_Amount FROM financial_loan
WHERE loan_status = 'Fully Paid'
   OR loan_status = 'Current';


# 10.
--    Bad Loan Application Percentage
SELECT COUNT(CASE
                 WHEN loan_status = 'Charged Off'
                 THEN ID
                 END) * 100
                 /
	   COUNT(ID) AS Bad_Loan_Application_Percentage
FROM financial_loan;


# 11.
--    Bad Loan Applications
SELECT COUNT(ID) AS Bad_Loan_Applications FROM financial_loan
WHERE loan_status = 'Charged Off';


# 12.
--    Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount FROM financial_loan
WHERE loan_status = 'Charged Off';


# 13.
--    Bad Loan Total Received Amount
SELECT SUM(total_payment) AS Bad_Loan_Received_Amount FROM financial_loan
WHERE loan_status = 'Charged Off';


# 14. 
--    Loan Status
SELECT loan_status, COUNT(id) AS TotalLoanApplications,
                    SUM(loan_amount) AS TotalFundedAmount,
                    SUM(total_payment) AS TotalAmountReceived,
                    SUM(CASE
                            WHEN MONTH(issue_date) = 12
                            THEN loan_amount
                            END) AS MTDFundedAmount,
                    SUM(CASE
                            WHEN MONTH(issue_date) = 12
                            THEN total_payment
                            END) AS MTDAmountReceived,
                    ROUND(AVG(int_rate * 100),2) AS AvgInterestRate,
                    ROUND(AVG(dti * 100),2) AS AvgDTI
FROM financial_loan
GROUP BY loan_status;


--------- Bank Loan Report | Overview ---------

# 1.
--    Monthly Trends by Issue Date 
SELECT MONTH(issue_date) AS MonthNumber,
       MONTHNAME(issue_date) AS MonthName,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY MONTHNAME(issue_date), MONTH(issue_date)
ORDER BY MONTH(issue_date);


# 2.
--    Regional Analysis
SELECT Address_State,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY Address_State
ORDER BY TotalLoanApplication DESC;


# 3.
--    Loan Tenure Analysis 
SELECT term AS LoanTenure,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY term;


# 4.
--    Employee Length Analysis
SELECT Emp_Length,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY Emp_Length
ORDER BY Emp_Length;


# 5.
--    Loan Purpose Breakdown
SELECT Purpose,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY Purpose
ORDER BY TotalLoanApplication DESC;


# 6.
--    Home Ownership Analysis
SELECT Home_Ownership,
       COUNT(id) AS TotalLoanApplication,
       SUM(loan_amount) AS TotalFundedAmount,
       SUM(total_payment) AS TotalAmountReceived
FROM financial_loan
GROUP BY Home_Ownership
ORDER BY TotalLoanApplication DESC;




