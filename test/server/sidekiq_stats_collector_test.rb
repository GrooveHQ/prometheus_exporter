# frozen_string_literal: true

require_relative '../test_helper'
require 'prometheus_exporter/server'
require 'prometheus_exporter/instrumentation'

class PrometheusSidekiqStatsCollectorTest < Minitest::Test
  def setup
    PrometheusExporter::Metric::Base.default_prefix = ''
  end

  def collector
    @collector ||= PrometheusExporter::Server::SidekiqStatsCollector.new
  end

  def test_collecting_metrics
    collector.collect(
      'stats' => {
        'dead_size' => 1,
        'enqueued' => 2,
        'failed' => 3,
        'processed' => 4,
        'processes_size' => 5,
        'retry_size' => 6,
        'scheduled_size' => 7,
        'workers_size' => 8,
      }
    )

    metrics = collector.metrics
    expected = [
      "sidekiq_stats_dead_size 1",
      "sidekiq_stats_enqueued 2",
      "sidekiq_stats_failed 3",
      "sidekiq_stats_processed 4",
      "sidekiq_stats_processes_size 5",
      "sidekiq_stats_retry_size 6",
      "sidekiq_stats_scheduled_size 7",
      "sidekiq_stats_workers_size 8"
    ]
    assert_equal expected, metrics.map(&:metric_text)
  end
end