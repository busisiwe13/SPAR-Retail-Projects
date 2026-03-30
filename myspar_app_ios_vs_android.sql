SELECT
  created_at,
  order_id,
  user_id,
  device_category[OFFSET(0)] device_category,
  operating_system[OFFSET(0)] operating_system,
  total_value

FROM (
  SELECT
    MIN(tOrders.delivery_slot.delivery_date) created_at,
    tOrders.id order_id,
    MIN(tOrders.user_id) user_id,
    ARRAY_AGG(tAnalytics.category IGNORE NULLS) device_category,
    ARRAY_AGG(tAnalytics.operating_system IGNORE NULLS) operating_system,
    MIN(tOrders.price.captured_price.total_price_vat) total_value,

  FROM `spar2u-375007.naveo_api_dataset.naveo_order_data_min` tOrders

  LEFT JOIN (
    SELECT
      user_id,
      device.category,
      device.operating_system
    FROM `spar2u-375007.analytics_cpy.events_intraday_*`
    
  ) tAnalytics ON tOrders.user_id = tAnalytics.user_id

  WHERE 
    tOrders.delivery_slot.delivery_date BETWEEN PARSE_DATE('%Y%m%d', @DS_START_DATE) AND PARSE_DATE('%Y%m%d', @DS_END_DATE)
    AND status = 'delivered'

  GROUP BY tOrders.id
)
