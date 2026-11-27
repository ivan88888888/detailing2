-- Виконані права для service_role:
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO service_role;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;

[
  {
    "columns": [
      {
        "table_name": "ad_spend",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "ad_spend",
        "column_name": "month",
        "data_type": "date",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "ad_spend",
        "column_name": "channel",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "ad_spend",
        "column_name": "amount_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "ad_spend",
        "column_name": "note",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "ad_spend",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "appointments",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "appointments",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "car_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "lead_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "kind",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'inspection'::text"
      },
      {
        "table_name": "appointments",
        "column_name": "starts_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "duration_min",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "assignee",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "status",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'planned'::text"
      },
      {
        "table_name": "appointments",
        "column_name": "notes",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "appointments",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "bonus_moves",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "kind",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "amount_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "order_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "expires_at",
        "data_type": "date",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "note",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "created_by",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "bonus_moves",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "cars",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "cars",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "brand",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "model",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "car_class",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "color",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "plate",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "year",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "cars",
        "column_name": "notes",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "clients",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "phone",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "telegram",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "viber",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "whatsapp",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "instagram",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "email",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "source",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "utm_source",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "utm_medium",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "utm_campaign",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "consent_processing",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "false"
      },
      {
        "table_name": "clients",
        "column_name": "consent_processing_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "consent_marketing",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "false"
      },
      {
        "table_name": "clients",
        "column_name": "consent_marketing_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "consent_version",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "notes",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "clients",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "clients",
        "column_name": "referred_by",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "conversations",
        "column_name": "channel",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "external_id",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "display_name",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "username",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "business_connection_id",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "last_text",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "conversations",
        "column_name": "last_message_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "conversations",
        "column_name": "unread",
        "data_type": "integer",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "conversations",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "integration_tokens",
        "column_name": "channel",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "integration_tokens",
        "column_name": "account_id",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "integration_tokens",
        "column_name": "token",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "integration_tokens",
        "column_name": "expires_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "integration_tokens",
        "column_name": "updated_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "leads",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "leads",
        "column_name": "lead_id_site",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "contact_method",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "contact",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "service_interest",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "status",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'new'::text"
      },
      {
        "table_name": "leads",
        "column_name": "lost_reason",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "assignee",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "first_response_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "next_contact_at",
        "data_type": "date",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "utm_source",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "utm_medium",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "utm_campaign",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "utm_content",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "utm_term",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "landing_page",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "referrer",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "consent_processing",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": "false"
      },
      {
        "table_name": "leads",
        "column_name": "consent_marketing",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": "false"
      },
      {
        "table_name": "leads",
        "column_name": "consent_version",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "car",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "car_class",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "preferred_time",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "comment",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "leads",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "leads",
        "column_name": "alert_level",
        "data_type": "integer",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "leads",
        "column_name": "tg_message_id",
        "data_type": "bigint",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "id",
        "data_type": "integer",
        "is_nullable": "NO",
        "column_default": "1"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "cashback_percent",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "bonus_valid_days",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "max_pay_share_percent",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "100"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "referral_referrer_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "referral_referred_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "referral_min_order_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "loyalty_settings",
        "column_name": "referral_max_per_referrer",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "materials",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "materials",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "materials",
        "column_name": "unit",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "materials",
        "column_name": "min_stock",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "materials",
        "column_name": "active",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "true"
      },
      {
        "table_name": "materials",
        "column_name": "note",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "messages",
        "column_name": "conversation_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "direction",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "text",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "ext_msg_id",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "sent_by",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "messages",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "order_items",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "order_items",
        "column_name": "order_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "service_id",
        "data_type": "bigint",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "price",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "currency",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'UAH'::text"
      },
      {
        "table_name": "order_items",
        "column_name": "qty",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "1"
      },
      {
        "table_name": "order_items",
        "column_name": "remind_at",
        "data_type": "date",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "revenue_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "materials_cost_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "order_items",
        "column_name": "labor_cost_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "order_photos",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "order_photos",
        "column_name": "order_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_photos",
        "column_name": "kind",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_photos",
        "column_name": "path",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "order_photos",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "orders",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "orders",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "car_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "appointment_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "status",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'accepted'::text"
      },
      {
        "table_name": "orders",
        "column_name": "discount_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "orders",
        "column_name": "usd_rate",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "payment_method",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "paid_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "paid_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "intake_notes",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "delivery_notes",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "delivered_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "orders",
        "column_name": "share_status",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "false"
      },
      {
        "table_name": "orders",
        "column_name": "public_token",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "replace((gen_random_uuid())::text, '-'::text, ''::text)"
      },
      {
        "table_name": "orders",
        "column_name": "material_factor",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "1"
      },
      {
        "table_name": "orders",
        "column_name": "stock_deducted",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "false"
      },
      {
        "table_name": "orders",
        "column_name": "materials_cost_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "total_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "labor_cost_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "orders",
        "column_name": "bonus_used_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "orders",
        "column_name": "bonus_accrued_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "service_norms",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "service_norms",
        "column_name": "service_id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "service_norms",
        "column_name": "material_id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "service_norms",
        "column_name": "qty",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "category",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "price_from",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "currency",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'UAH'::text"
      },
      {
        "table_name": "services",
        "column_name": "price_text",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "duration_text",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "return_interval_days",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "services",
        "column_name": "active",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "true"
      },
      {
        "table_name": "services",
        "column_name": "sort",
        "data_type": "integer",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "services",
        "column_name": "work_minutes",
        "data_type": "integer",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "settings",
        "column_name": "id",
        "data_type": "integer",
        "is_nullable": "NO",
        "column_default": "1"
      },
      {
        "table_name": "settings",
        "column_name": "hourly_cost_uah",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": "0"
      },
      {
        "table_name": "staff",
        "column_name": "user_id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "staff",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "staff",
        "column_name": "role",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": "'owner'::text"
      },
      {
        "table_name": "stock_moves",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "material_id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "kind",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "qty",
        "data_type": "numeric",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "unit_cost_uah",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "order_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "note",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "created_by",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "stock_moves",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "tg_connections",
        "column_name": "id",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "tg_connections",
        "column_name": "user_id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "tg_connections",
        "column_name": "can_reply",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "true"
      },
      {
        "table_name": "tg_connections",
        "column_name": "is_enabled",
        "data_type": "boolean",
        "is_nullable": "NO",
        "column_default": "true"
      },
      {
        "table_name": "timeline",
        "column_name": "id",
        "data_type": "uuid",
        "is_nullable": "NO",
        "column_default": "gen_random_uuid()"
      },
      {
        "table_name": "timeline",
        "column_name": "client_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "timeline",
        "column_name": "lead_id",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "timeline",
        "column_name": "kind",
        "data_type": "text",
        "is_nullable": "NO",
        "column_default": null
      },
      {
        "table_name": "timeline",
        "column_name": "text",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "timeline",
        "column_name": "created_by",
        "data_type": "uuid",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "timeline",
        "column_name": "created_at",
        "data_type": "timestamp with time zone",
        "is_nullable": "NO",
        "column_default": "now()"
      },
      {
        "table_name": "v_stock",
        "column_name": "id",
        "data_type": "bigint",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "name",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "unit",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "min_stock",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "active",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "balance",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      },
      {
        "table_name": "v_stock",
        "column_name": "avg_cost",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null
      }
    ],
    "rls_tables": [
      {
        "tablename": "ad_spend",
        "rowsecurity": true
      },
      {
        "tablename": "appointments",
        "rowsecurity": true
      },
      {
        "tablename": "bonus_moves",
        "rowsecurity": true
      },
      {
        "tablename": "cars",
        "rowsecurity": true
      },
      {
        "tablename": "clients",
        "rowsecurity": true
      },
      {
        "tablename": "conversations",
        "rowsecurity": true
      },
      {
        "tablename": "integration_tokens",
        "rowsecurity": true
      },
      {
        "tablename": "leads",
        "rowsecurity": true
      },
      {
        "tablename": "loyalty_settings",
        "rowsecurity": true
      },
      {
        "tablename": "materials",
        "rowsecurity": true
      },
      {
        "tablename": "messages",
        "rowsecurity": true
      },
      {
        "tablename": "order_items",
        "rowsecurity": true
      },
      {
        "tablename": "order_photos",
        "rowsecurity": true
      },
      {
        "tablename": "orders",
        "rowsecurity": true
      },
      {
        "tablename": "service_norms",
        "rowsecurity": true
      },
      {
        "tablename": "services",
        "rowsecurity": true
      },
      {
        "tablename": "settings",
        "rowsecurity": true
      },
      {
        "tablename": "staff",
        "rowsecurity": true
      },
      {
        "tablename": "stock_moves",
        "rowsecurity": true
      },
      {
        "tablename": "tg_connections",
        "rowsecurity": true
      },
      {
        "tablename": "timeline",
        "rowsecurity": true
      }
    ],
    "policies": [
      {
        "schemaname": "public",
        "tablename": "ad_spend",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "appointments",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "bonus_moves",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "cars",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "clients",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "conversations",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "leads",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "loyalty_settings",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "materials",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "messages",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "order_items",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "order_photos",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "orders",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "service_norms",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "services",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "settings",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "staff",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "(auth.uid() = user_id)",
        "with_check": "(auth.uid() = user_id)"
      },
      {
        "schemaname": "public",
        "tablename": "stock_moves",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "tg_connections",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      },
      {
        "schemaname": "public",
        "tablename": "timeline",
        "policyname": "лише команда",
        "permissive": "PERMISSIVE",
        "roles": [
          "authenticated"
        ],
        "cmd": "ALL",
        "qual": "is_staff()",
        "with_check": "is_staff()"
      }
    ],
    "routines": [
      {
        "routine_name": "inbox_add_message",
        "data_type": "uuid",
        "routine_definition": "\ndeclare cid uuid; n int;\nbegin\n  insert into conversations (channel, external_id, display_name, username, business_connection_id, client_id)\n  values (p_channel, p_external_id, p_name, p_username, p_conn,\n    (select c.id from clients c where\n       (p_channel = 'telegram' and p_username is not null and lower(replace(coalesce(c.telegram, ''), '@', '')) = lower(p_username)) or\n       (p_channel = 'instagram' and p_username is not null and lower(regexp_replace(coalesce(c.instagram, ''), '^.*instagram\\.com/|[@/]', '', 'g')) = lower(p_username)) or\n       (p_channel = 'whatsapp' and regexp_replace(coalesce(c.phone, ''), '\\D', '', 'g') = p_external_id)\n     limit 1))\n  on conflict (channel, external_id) do update set display_name = coalesce(excluded.display_name, conversations.display_name),\n    username = coalesce(excluded.username, conversations.username), business_connection_id = coalesce(excluded.business_connection_id, conversations.business_connection_id)\n  returning id into cid;\n  insert into messages (conversation_id, direction, text, ext_msg_id, sent_by, created_at) values (cid, p_direction, p_text, p_ext_msg_id, p_sent_by, p_at)\n  on conflict (conversation_id, ext_msg_id) do nothing;\n  get diagnostics n = row_count;\n  if n = 1 then\n    update conversations set last_text = left(coalesce(p_text, ''), 200), last_message_at = p_at, unread = case when p_direction = 'out' then 0 else unread + 1 end where id = cid;\n  end if;\n  return cid;\nend "
      },
      {
        "routine_name": "is_staff",
        "data_type": "boolean",
        "routine_definition": " select exists (select 1 from staff where user_id = auth.uid()) "
      },
      {
        "routine_name": "on_lead_created",
        "data_type": "trigger",
        "routine_definition": " begin insert into timeline (lead_id, kind, text) values (new.id, 'lead', 'Заявку отримано з сайту'); return new; end "
      }
    ]
  }
]