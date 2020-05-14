SELECT
subname as subscription_name,
EXTRACT(EPOCH FROM AGE(NOW(), last_msg_receipt_time)) AS sub_msg_lag
FROM pg_stat_subscription;
