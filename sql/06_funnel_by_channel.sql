SELECT 
  medium,
  COUNT(*) AS sessions,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(s_view) AS view_item,
  COUNTIF(s_cart) AS add_to_cart,
  COUNTIF(s_checkout) AS begin_checkout,
  COUNTIF(s_purchase) AS purchase,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(s_view), COUNT(*)), 2) AS cr_session_to_view,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(s_cart), COUNTIF(s_view)), 2) AS cr_view_to_cart,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(s_checkout), COUNTIF(s_cart)), 2) AS cr_cart_to_checkout,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(s_purchase), COUNTIF(s_checkout)), 2) AS cr_checkout_to_purchase,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(s_purchase), COUNT(*)), 2) AS cr_total
FROM `myproject-513713.ga4_funnel.sessions`
GROUP BY medium
HAVING sessions >= 1000 
ORDER BY sessions DESC;