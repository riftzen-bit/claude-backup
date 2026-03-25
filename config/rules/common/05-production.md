# Production Readiness

## Performance

Check every loop:
- Nested loop over same data? Verify O(n^2) is justified
- Database query inside a loop? N+1 problem — use batch/eager loading
- Loading entire dataset? Use streaming/pagination
- SELECT * on large tables? Select only needed columns
- Missing WHERE/LIMIT? Unbounded query

Run EXPLAIN ANALYZE on generated queries. Index: foreign keys, WHERE columns, ORDER BY columns.

## Resilience

External services must have: connection + read timeouts, retries with exponential backoff + jitter, circuit breakers, graceful degradation.

Handle: connection pool exhaustion, DNS failures, rate limiting (429), network partitions.

## Concurrency

- Check shared mutable state (#1 race condition source), missing locks/atomics, global mutable state
- Caching: shared cache (Redis) for multi-instance. All caches: TTL, eviction, max size, invalidation

## Resource Cleanup

Every subscription/listener/timer/connection has matching cleanup:
- addEventListener→removeEventListener, setInterval→clearInterval, .on()→.off(), subscribe()→unsubscribe()
- WebSocket/DB connections closed on shutdown (SIGTERM, SIGINT)
- Buffers/queues: bounded size with backpressure

## Real-Time Patterns

WebSocket/SSE: reconnection with backoff, heartbeat, message queue for offline, graceful shutdown, bounded buffers. Never assume connections reliable.

## API Backward Compatibility

All API changes additive. New fields can be added, existing fields never removed/renamed without deprecation. Envelope format stable.

## Platform Safety

- path.join()/pathlib, not hardcoded / or \
- Handle \r\n, \n, \r line endings
- os.tmpdir()/tempfile, not hardcoded /tmp
- Max path: 260 chars on Windows

## Deployment

Never assume: local file paths, localhost databases, single-instance. Use configurable connection strings and env vars.
