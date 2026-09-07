# LocalMesh Review Demo

This repository is a separate consumer of [LocalMesh Sensei](https://github.com/ritwin82/Dot75). It contains a baseline PostgreSQL schema and four cross-PR conflict demonstrations.

## Review flow

1. Start the Dot75 platform with `docker compose up --build`.
2. Keep the `localmesh-demo-publisher` self-hosted runner online.
3. Follow [DEMO_SCENARIOS.md](DEMO_SCENARIOS.md).
4. Open PR A and wait for its standalone pass.
5. Open PR B and inspect the `LocalMesh Sensei` Check, sticky comment, and dashboard result.
6. Close both PRs without merging before starting the next pair.

GitHub-hosted runners execute untrusted migration SQL in disposable PostgreSQL containers. The self-hosted publisher only verifies and publishes the result to GitHub and the local dashboard.
