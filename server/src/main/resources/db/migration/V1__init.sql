CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Multi-tenant desde o dia 1. O modo pessoal usa o tenant padrão.
CREATE TABLE tenant (
                        id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                        name       text        NOT NULL,
                        slug       text        NOT NULL UNIQUE,
                        created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO tenant (id, name, slug)
VALUES ('00000000-0000-0000-0000-000000000001', 'Default', 'default');

CREATE TABLE host (
                      id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                      tenant_id      uuid        NOT NULL REFERENCES tenant (id),
                      hostname       text        NOT NULL,
                      os             text,
                      agent_version  text,
                      first_seen_at  timestamptz NOT NULL DEFAULT now(),
                      last_seen_at   timestamptz NOT NULL DEFAULT now(),
                      UNIQUE (tenant_id, hostname)
);

CREATE TABLE metric (
                        time      timestamptz      NOT NULL,
                        tenant_id uuid             NOT NULL,
                        host_id   uuid             NOT NULL REFERENCES host (id),
                        name      text             NOT NULL,
                        value     double precision NOT NULL,
                        tags      jsonb
);

SELECT create_hypertable('metric', 'time');
CREATE INDEX idx_metric_host_name_time ON metric (host_id, name, time DESC);

-- Retenção padrão de 30 dias (ajustável por tenant em fase futura).
SELECT add_retention_policy('metric', INTERVAL '30 days');