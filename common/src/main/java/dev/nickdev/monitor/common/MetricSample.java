package dev.nickdev.monitor.common;

import java.time.Instant;

/** Uma medição pontual (ex.: cpu.usage.percent = 37.5). */
public record MetricSample(
        String name,
        double value,
        Instant time
) {}