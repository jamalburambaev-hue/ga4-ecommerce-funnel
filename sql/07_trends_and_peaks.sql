-- По неделям
SELECT 
  DATE_TRUNC(session_date, WEEK(MONDAY)) AS week_start,
  COUNT(*) AS sessions,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(has_purchase) AS purchases,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(has_purchase), COUNT(*)), 2) AS cr_total_pct,
  ROUND(SUM(revenue_usd), 0) AS revenue_usd
FROM `myproject-513713.ga4_funnel.sessions`
GROUP BY week_start
ORDER BY week_start;

-- Топ-10 дней по выручке
SELECT 
  session_date,
  COUNT(*) AS sessions,
  COUNTIF(has_purchase) AS purchases,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(has_purchase), COUNT(*)), 2) AS cr_total_pct,
  ROUND(SUM(revenue_usd), 0) AS revenue_usd
FROM `myproject-513713.ga4_funnel.sessions`
GROUP BY session_date
ORDER BY revenue_usd DESC
LIMIT 10;