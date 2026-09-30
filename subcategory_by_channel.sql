-- Subcategory breakdown of MAU, Browser, Adviews, Responder, Leads by Channels

WITH
  users AS (
    SELECT
      date_trunc(date(event_date), month) AS date,
      CASE
        WHEN (vertical = 'Auto' AND subcategory = 'Cars') THEN "Cars"
        WHEN (vertical = 'Property' AND ad_type IN ('For rent', 'rent', 'let'))
          THEN "Property For Rent"
        WHEN
          (
            vertical = 'Property'
            AND ad_type IN ('For sale', 'sell', 'buy', 'auction', 'newprop'))
          THEN "Property For Sale"
        ELSE "Others"
        END AS vertical,
      CASE
        WHEN
          channel_grouping IN ('Direct', 'Direct Traffic')
          THEN "Direct"
        WHEN
          channel_grouping IN ("Organic Search")
          THEN "Organic Search"
        WHEN lower(medium) IN ('cpc', 'paid') THEN "Paid"
        WHEN
          channel_grouping IN ('Mobile Push Notifications')
          THEN "Push Notifications"
        ELSE "Others"
        END AS channels,
      COUNT(DISTINCT au_id) AS mau,  
    FROM `md-sa-dwh.fact_history.gs_users_fact`
    WHERE
      vertical IN ('Property', 'Auto')
      AND date(event_date) >= '2026-01-01'
    GROUP BY ALL
  ),
  adv AS (
    SELECT
      date_trunc(date(event_date), month) AS date,
      CASE
        WHEN (vertical = 'Auto' AND subcategory = 'Cars') THEN "Cars"
        WHEN (vertical = 'Property' AND ad_type IN ('For rent', 'rent', 'let'))
          THEN "Property For Rent"
        WHEN
          (
            vertical = 'Property'
            AND ad_type IN ('For sale', 'sell', 'buy', 'auction', 'newprop'))
          THEN "Property For Sale"
        ELSE "Others"
        END AS vertical,
      CASE
        WHEN
          channel_grouping IN ('Direct', 'Direct Traffic')
          THEN "Direct"
        WHEN
          channel_grouping IN ("Organic Search")
          THEN "Organic Search"
        WHEN lower(medium) IN ('cpc', 'paid') THEN "Paid"
        WHEN
          channel_grouping IN ('Mobile Push Notifications')
          THEN "Push Notifications"
        ELSE "Others"
        END AS channels,
      COUNT(DISTINCT au_id) AS browsers,
      sum(adviews) AS adviews
    FROM `md-sa-dwh.fact_history.gs_adviews_fact`
    WHERE
      vertical IN ('Property', 'Auto')
      AND date(event_date) >= '2026-01-01'
    GROUP BY ALL
  ),
  ld AS (
    SELECT
      date_trunc(date(event_date), month) AS date,
      CASE
        WHEN (vertical = 'Auto' AND subcategory = 'Cars') THEN "Cars"
        WHEN (vertical = 'Property' AND ad_type IN ('For rent', 'rent', 'let'))
          THEN "Property For Rent"
        WHEN
          (
            vertical = 'Property'
            AND ad_type IN ('For sale', 'sell', 'buy', 'auction', 'newprop'))
          THEN "Property For Sale"
        ELSE "Others"
        END AS vertical,
      CASE
        WHEN
          channel_grouping IN ('Direct', 'Direct Traffic')
          THEN "Direct"
        WHEN
          channel_grouping IN ("Organic Search")
          THEN "Organic Search"
        WHEN lower(medium) IN ('cpc', 'paid') THEN "Paid"
        WHEN
          channel_grouping IN ('Mobile Push Notifications')
          THEN "Push Notifications"
        ELSE "Others"
        END AS channels,
      COUNT(DISTINCT au_id) AS responders,
      sum(leads) AS leads
    FROM `md-sa-dwh.fact_history.gs_leads_fact`
    WHERE
      vertical IN ('Property', 'Auto')
      AND date(event_date) >= '2026-01-01'
    GROUP BY ALL
  )
SELECT
  users.date,
  users.vertical,
  users.channels,
  users.mau,
  adv.browsers,
  adv.adviews,
  ld.responders,
  ld.leads
FROM users
JOIN adv
  USING (date, vertical, channels)
JOIN ld
  USING (date, vertical, channels)
ORDER BY 1
