WITH downloads AS (
  SELECT
    *,
    null AS uninstalls,
    "iOS" AS platform
  FROM `spar2u-375007.ios_app_store.ios_installs_overview`

  UNION ALL

  SELECT *
  FROM (
    SELECT
      Date AS date,
      Install_events AS installs,
      Update_events AS updates,
      Uninstall_events AS uninstalls,
      "ANDROID" AS platform

    FROM `spar2u-375007.google_play_store.p_Installs_overview_mt`

    WHERE Package_name = "za.co.spar2u"
  )
)

SELECT
  downloads.date,
  downloads.installs,
  downloads.updates,
  downloads.uninstalls,
  downloads.platform,
  tCal.year,
  tCal.month,
SAFE.PARSE_DATE("%Y-%m-%d", CONCAT(tCal.Year, "-", tCal.Month, "-", "01")) fin_date

FROM downloads

LEFT JOIN `global_dataset.financial_calendar` tCal ON tCal.Date = downloads.date

