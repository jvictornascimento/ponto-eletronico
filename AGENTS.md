# Repository Guidelines

## Project Structure & Module Organization

This repository currently contains no application source files, tests, or build manifests. Keep future structure explicit and conventional:

- `src/` for production application code.
- `tests/` or language-standard test folders such as `src/test/` for automated tests.
- `assets/` or `public/` for static files such as images, styles, and fixtures.
- `docs/` for design notes, API references, and operational runbooks.

When adding a framework, commit the package or build manifest (`package.json`, `pom.xml`, `build.gradle`, `Makefile`, etc.) with the initial source layout.

## Build, Test, and Development Commands

No project-specific commands are available yet. Add commands to this section as soon as the project gains a toolchain. Prefer reproducible, single-entry commands, for example:

- `npm install` - install JavaScript dependencies.
- `npm run dev` - start the local development server.
- `npm test` - run the automated test suite.
- `./mvnw test` - run Java tests through the Maven wrapper.

If multiple services are introduced, document required environment variables and startup order.

## Coding Style & Naming Conventions

Follow the formatter and linter configured by the chosen stack. Commit configuration files with the first implementation, such as `.editorconfig`, `.prettierrc`, `eslint.config.*`, `checkstyle.xml`, or equivalent.

Use descriptive names that match the language convention: `camelCase` for JavaScript/TypeScript variables, `PascalCase` for React components or Java classes, and `kebab-case` for static asset filenames. Keep modules focused and avoid mixing unrelated responsibilities in one file.

## Testing Guidelines

Add tests with each behavioral change. Place tests near the code when the framework encourages it, or under a dedicated `tests/` tree. Use clear names that describe behavior, such as `shouldRecordClockInWhenEmployeeIsActive`.

Document the test command and any coverage expectations once a test framework is selected. Include fixtures under `tests/fixtures/` or an equivalent clearly named directory.

## Commit & Pull Request Guidelines

Git history is not available in this workspace, so no existing commit convention can be inferred. Until one is adopted, use short imperative commit messages, optionally with a scope:

- `Add employee time entry model`
- `Fix overtime calculation`

Pull requests should include a concise description, linked issue when applicable, test results, and screenshots for UI changes. Note any schema, configuration, or migration steps clearly.

## Agent-Specific Instructions

Before editing, inspect the current repository state and avoid assuming a framework that is not present. Keep changes scoped, document new commands here, and do not remove user-created files unless explicitly requested.
