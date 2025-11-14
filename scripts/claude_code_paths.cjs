/**
 * Shared configuration for Claude Code CLI paths
 *
 * This module provides the canonical list of paths/module specifiers
 * for locating the Claude Code CLI across different versions and installations.
 *
 * Used by:
 * - claude_local_launcher.cjs (dynamic imports)
 * - claude_remote_launcher.cjs (dynamic imports)
 * - src/claude/sdk/utils.ts (filesystem paths)
 */

/**
 * Module specifiers for dynamic import() calls
 * Ordered by preference - try each in sequence
 */
const MODULE_SPECIFIERS = [
  '@anthropic-ai/claude-code/cli.js',      // Standard location
  '@anthropic-ai/claude-code',             // Package root (fallback)
  '@anthropic-ai/claude-code/dist/cli.js'  // Build output location
];

/**
 * Relative path segments within node_modules/@anthropic-ai/claude-code/
 * Used for constructing filesystem paths
 * Ordered by preference - try each in sequence
 */
const PATH_SEGMENTS = [
  'cli.js',       // Standard location
  'bin/cli.js',   // Alternative bin location
  'dist/cli.js'   // Build output location
];

/**
 * Attempts to import Claude Code CLI using fallback module specifiers
 * Tries each specifier in order until one succeeds
 * Exits process with error if all attempts fail
 */
async function loadClaudeCodeCli() {
  const errors = [];

  for (const specifier of MODULE_SPECIFIERS) {
    try {
      await import(specifier);
      return; // Success! Exit the function
    } catch (error) {
      errors.push({ specifier, error });
    }
  }

  // If we get here, all attempts failed
  console.error('Failed to load Claude Code CLI. Tried:');
  for (const { specifier, error } of errors) {
    console.error(`  - ${specifier}: ${error.message}`);
  }
  process.exit(1);
}

module.exports = {
  MODULE_SPECIFIERS,
  PATH_SEGMENTS,
  loadClaudeCodeCli
};
