-- Период и объём данных
SELECT 
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date, 
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS last_date, 
  COUNT(*) AS events, 
  COUNT(DISTINCT user_pseudo_id) AS users 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';

-- Какие события есть и как часто
SELECT 
  event_name, 
  COUNT(*) AS events, 
  COUNT(DISTINCT user_pseudo_id) AS users 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name 
ORDER BY events DESC;

-- Значения устройств и каналов
SELECT 
  device.category AS device_category, 
  traffic_source.medium AS medium, 
  COUNT(DISTINCT user_pseudo_id) AS users 
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY device_category, medium 
ORDER BY users DESC;