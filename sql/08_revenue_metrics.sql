-- По каналам
SELECT 
  medium,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(DISTINCT IF(has_purchase, user_pseudo_id, NULL)) AS buyers,
  COUNTIF(has_purchase) AS purchases,
  ROUND(SUM(revenue_usd), 0) AS revenue_usd,
  ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNT(DISTINCT user_pseudo_id)), 2) AS arpu_usd,
  ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNTIF(has_purchase)), 2) AS aov_usd
FROM `myproject-513713.ga4_funnel.sessions`
GROUP BY medium
HAVING users >= 1000
ORDER BY revenue_usd DESC;

-- По устройствам
SELECT 
  device_category,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(has_purchase) AS purchases,
  ROUND(SUM(revenue_usd), 0) AS revenue_usd,
  ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNTIF(has_purchase)), 2) AS aov_usd,
  ROUND(SAFE_DIVIDE(SUM(revenue_usd), COUNT(*)), 3) AS revenue_per_session_usd
FROM `myproject-513713.ga4_funnel.sessions`
GROUP BY device_category
ORDER BY revenue_usd DESC;