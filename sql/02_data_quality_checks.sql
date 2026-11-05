-- Доля событий без ga_session_id
SELECT 
  COUNTIF((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') IS NULL) AS events_no_session, 
  COUNT(*) AS all_events 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';

-- Покупки: дубликаты и пустая выручка
SELECT 
  COUNT(*) AS purchase_events, 
  COUNT(DISTINCT ecommerce.transaction_id) AS unique_transactions, 
  COUNTIF(ecommerce.transaction_id IS NULL OR ecommerce.transaction_id = '(not set)') AS no_transaction_id, 
  COUNTIF(ecommerce.purchase_revenue_in_usd IS NULL OR ecommerce.purchase_revenue_in_usd = 0) AS zero_revenue 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' 
  AND event_name = 'purchase';

-- События по дням: нет ли провалов и аномалий
SELECT 
  PARSE_DATE('%Y%m%d', event_date) AS dt, 
  COUNT(*) AS events, 
  COUNT(DISTINCT user_pseudo_id) AS users 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' 
GROUP BY dt 
ORDER BY dt;