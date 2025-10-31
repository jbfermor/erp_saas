## Quick orientation

- This repository is a Ruby on Rails 8 application (see `Gemfile` — `gem "rails", "~> 8.0.4"`).
- Database: PostgreSQL (see `Gemfile` -> `pg`).
- Asset pipeline: Propshaft + a small CSS build using `sass` + `postcss`/`autoprefixer`. The generated CSS lives at `app/assets/builds/application.css` and is produced by yarn scripts in `package.json`.

## Where to look first (high-value files)

- App code: `app/controllers`, `app/models`, `app/views`, `app/jobs`, `app/mailers`.
- Frontend assets: `app/assets/stylesheets/` (sources) and `app/assets/builds/application.css` (generated). See `package.json` scripts for exact commands.
- Startup: `bin/dev` (local dev launcher that invokes `Procfile.dev`). `Procfile.dev` defines the `web` and `css` processes used in development.
- Queues / jobs: `config/queue.yml` and `app/jobs/`. The project uses `solid_queue` (see `Gemfile`).
- Server config: `config/puma.rb` (note the `solid_queue` plugin usage guarded by `SOLID_QUEUE_IN_PUMA`).
- Deployment helpers: `kamal` is present (in `Gemfile`) and `thruster` is available for Puma optimizations.

## Local development workflows (explicit commands)

- Start local dev environment (uses `foreman` via `bin/dev`):

  - `./bin/dev` — runs the processes from `Procfile.dev` (web + css watcher). `bin/dev` will install `foreman` if missing.

- Start only Rails server:

  - `env RUBY_DEBUG_OPEN=true bin/rails server` (this is what `Procfile.dev` uses for `web`).

- CSS build/watch (yarn):

  - Build once: `yarn build:css` (runs `sass` compile then `postcss` autoprefix).
  - Watch for changes: `yarn watch:css` (nodemon watches `app/assets/stylesheets` and runs `yarn build:css`).

  These scripts are defined in `package.json` — use them when changing styles.

## Background jobs and process boundaries

- The app uses `solid_queue` / `solid_cache` / `solid_cable` (see `Gemfile`). Check `config/queue.yml` for the default worker/dispatcher settings (polling intervals, threads, processes).
- In production, Puma can be configured to run the Solid Queue supervisor in-process by setting `SOLID_QUEUE_IN_PUMA` (see `config/puma.rb`). Be careful: that couples HTTP and job lifecycles.

## Conventions and repo-specific patterns

- `config.autoload_lib(ignore: %w[assets tasks])` in `config/application.rb` means some `lib/` subdirs are intentionally not reloaded; prefer placing reloadable code under `lib/*.rb` or `app/` unless intentionally static.
- Stylesheets: source SCSS are under `app/assets/stylesheets/*.scss` and compiled into `app/assets/builds/application.css` — do not manually edit files in `app/assets/builds/` (they are generated).
- No heavy JS stack: dependencies are limited to `sass`, `postcss`, `bootstrap`, `bootstrap-icons` — keep frontend edits minimal and follow the `package.json` scripts.

## Editing guidance for AI agents (concrete, actionable)

- When changing server behavior, check `config/puma.rb` first for thread/worker defaults and the `SOLID_QUEUE_IN_PUMA` plugin.
- When adding or modifying background job behavior, update `app/jobs/*` and validate `config/queue.yml` settings; run any local worker or confirm behavior via unit tests (if present) or local job simulation.
- When modifying styles:
  - Edit SCSS in `app/assets/stylesheets/`.
  - Run `yarn build:css` to produce `app/assets/builds/application.css` and include in PR the generated build file only if the repo's CI expects it — otherwise indicate in PR that CSS was built locally and where changes were made.
- For local full-stack development, use `./bin/dev` so both the Rails server and CSS watcher run together (this is the recommended local workflow).

## Tests, linters, and static analysis

- The repository includes `rubocop-rails-omakase` and `brakeman` in the development/test groups (`Gemfile`) but there is no explicit test framework gem (e.g., RSpec) declared; run `bin/rails test` if tests are present.
- If you add static analysis changes, reference the project's existing tools: `rubocop` and `brakeman`.

## Deployment and ops notes

- The repo includes `kamal` (deploy helper) and `thruster` (Puma optimizations). For containerized/deploy flows, search for `Kamal` configs or `deploy.yml` — changes to puma or queue behavior may require accompanying deploy config updates.

## Helpful file examples (quick references)

- CSS build script (from `package.json`):

  - `"build:css": "yarn build:css:compile && yarn build:css:prefix"`

- Local Procfile (`Procfile.dev`):

  - `web: env RUBY_DEBUG_OPEN=true bin/rails server`
  - `css: yarn watch:css`

- Local launcher: `bin/dev` (installs `foreman` if missing and runs the `Procfile.dev`).

## If something's unclear

- Ask for the intended environment (development vs production) and whether generated assets should be committed. If editing background job behavior, ask whether the team prefers running queue supervisors in Puma (`SOLID_QUEUE_IN_PUMA`) or as separate processes.

---
If you'd like, I can iterate this file with more examples (e.g., common `rails` commands you prefer, important Rake tasks, or CI hooks). What should I expand or clarify next?
