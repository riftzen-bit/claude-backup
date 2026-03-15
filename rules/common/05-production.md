# Production Readiness

## Performance

Check every loop:
- Nested loop over same data? Verify O(n^2) is justified
- Database query inside a loop? N+1 problem — use batch/eager loading
- Loading entire dataset into memory? Use streaming/pagination
- SELECT * on large tables? Select only needed columns
- Missing WHERE clause or LIMIT? Unbounded query

Run EXPLAIN ANALYZE on generated queries. Ensure indexes on: foreign keys, WHERE columns, ORDER BY columns.

## Resilience

All code handling external services includes:
- Connection + read timeouts
- Retries with exponential backoff and jitter
- Circuit breakers for cascading failure prevention
- Graceful degradation when service is down

Handle: connection pool exhaustion, DNS failures, rate limiting (429), network partitions.

## Concurrency

Review all concurrent code for:
- Shared mutable state (the #1 source of race conditions)
- Missing locks/atomics/synchronization
- Global/module-level mutable state

Caching: use shared cache (Redis) for multi-instance deployments, not in-memory. All caches need: TTL, eviction policy, max size, invalidation strategy.

## Resource Cleanup

Every subscription, listener, timer, or connection has a matching cleanup:
- addEventListener → removeEventListener
- setInterval → clearInterval
- .on() → .off()
- subscribe() → unsubscribe()
- WebSocket/DB connections closed on shutdown (SIGTERM, SIGINT)

Buffers and queues: bounded size with backpressure.

## Real-Time Patterns

WebSocket/SSE: include reconnection with exponential backoff, heartbeat/ping-pong, message queue for offline periods, graceful shutdown, bounded message buffers.

Never assume connections are reliable. Handle: network interruptions, server restarts, proxy timeouts (60-120s), browser tab suspension.

## API Backward Compatibility

All API changes are additive by default. New fields can be added, existing fields cannot be removed or renamed without deprecation period. Response envelope format does not change.

## Platform Safety

- Use path.join() or pathlib, not hardcoded / or \
- Handle \r\n, \n, and \r line endings
- Use os.tmpdir() / tempfile, not hardcoded /tmp
- Never assume bash/sh/cmd availability
- Max path length: 260 chars on Windows

## Deployment

Do not assume: local file paths, localhost databases, single-instance deployment. Use configurable connection strings and env vars.
