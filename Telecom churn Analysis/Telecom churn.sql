

 -- telecom data import from kaggle.com --

select*from telechurn

-- Calculating Percentage of churn rate --

select
count(case when "Churn" = 'Yes' then 1 end)*100.0/count(*) as churn_rate
from telechurn

-- Cohort Analysis (Tenure-Based)--

select
  case 
  when "tenure" between 0 and 12 then '0-12 month'
  when "tenure" between 13 and 24 then '13-24 month'
  when "tenure" between 25 and 48 then '25-48 month'
  else '49+month'
  end as tenure_group,
  count(*) as  total_churn,
  sum(case when "Churn" = 'Yes' then 1 else 0 end ) as churned_customer,
  round(sum(case when "Churn" = 'Yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate
  from telechurn
   group by tenure_group
   order by churn_rate desc


 --Customer Segmentation--

select 
  "customerid",
  "Contract",
  "MonthlyCharges",
  "tenure",
  "Churn",
       Case when "Churn"= 'Yes' then 'churned'
	   when "Contract"='Month-to-month' and "MonthlyCharges" > 80 and "tenure" <12 then 'high risk'
	   when "Contract"= 'Month-to-month' then 'medium risk'
	   when "Contract" IN('one year','two year') and "tenure" >24 then 'loyal'
	   else 'stable'
	   end as Risk_Segment
	   from telechurn





--Segment Churn rates by Contract type--
select 
       "Contract",
	   count(*) as Total_customers,
	   sum(Case when "Churn" = 'Yes' then 1 else 0 end)  as churned_customer,
	   round(sum(case when "Churn" = 'Yes' then 1 else 0 end )*100.0 /COUNT(*),2) as churn_rate
	   from telechurn 
	   group by "Contract"

--Payment method churn--

select 
       "PaymentMethod",
	   count(*) as Total_customers,
	   sum(Case when "Churn" = 'Yes' then 1 else 0 end)  as churned_customer,
	   round(sum(case when "Churn" = 'Yes' then 1 else 0 end )*100.0 /COUNT(*),2) as churn_rate
	   from telechurn 
	   group by "PaymentMethod"


-- High risk customer--

	   SELECT 
    "customerid",
    "gender",
    "Contract",
    "tenure",
    "MonthlyCharges",
    "PaymentMethod",
    CASE
        WHEN "Contract"='Month-to-month' AND "MonthlyCharges" > 80 AND "tenure" < 12 THEN 'High Risk'
        ELSE 'Low/Medium Risk'
    END AS risk_level
FROM telechurn
WHERE "Churn"='No'
ORDER BY "MonthlyCharges" DESC;