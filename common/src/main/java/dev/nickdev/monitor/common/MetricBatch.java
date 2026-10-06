package dev.nickdev.monitor.common;

import java.util.List;

/** Lote enviado pelo agente ao servidor (push). */
public record MetricBatch(
        String hostname,
        String os,
        String agentVersion,
        List<MetricSample> samples
) {}