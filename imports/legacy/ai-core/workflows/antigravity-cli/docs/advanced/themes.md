<!-- topic: themes | section: advanced -->
# Themes

## Quick Reference

> - Themes change Gemini CLI's visual color palette without changing model behavior.
> - Built-in themes include `default`, `dark`, `light`, `solarized`, `dracula`, `github-light`, and `github-dark`.
> - Set a persistent theme in `settings.json` with the top-level `theme` key.
> - Use `/theme <name>` to switch the current session, or `/theme` to see the current theme.
> - Add custom themes as JSON files in `~/.gemini/themes/`.

## What Themes Control

A theme controls the colors Gemini CLI uses for interface elements such as primary text, accents, status colors, and background tones. Themes affect the terminal presentation only; they do not change prompts, models, tool permissions, or execution behavior.

## Built-In Themes

| Theme |
|---|
| `default` |
| `dark` |
| `light` |
| `solarized` |
| `dracula` |
| `github-light` |
| `github-dark` |

## Set a Theme Persistently

To make a theme the default across sessions, set the top-level `theme` field in `settings.json`:

```json
{
  "theme": "dark"
}
```

This is the right approach for a long-term personal preference.

## Change the Theme for the Current Session

Use the slash command in an interactive session:

```text
/theme <name>
```

Run `/theme` with no argument to see the current theme.

This is useful when you want to experiment temporarily without changing the persistent configuration.

## Custom Themes

Gemini CLI can load custom themes from JSON files in:

```text
~/.gemini/themes/<name>.json
```

The theme name is the filename without the `.json` extension.

For example, `~/.gemini/themes/my-theme.json` becomes the theme named `my-theme`.

## Theme File Format

```json
{
  "name": "my-theme",
  "colors": {
    "primary": "#61dafb",
    "secondary": "#282c34",
    "background": "#1e1e1e",
    "text": "#ffffff",
    "accent": "#ff7043",
    "error": "#f44336",
    "warning": "#ff9800",
    "success": "#4caf50"
  }
}
```

The `name` field describes the theme, and the `colors` object defines the UI palette Gemini CLI should use when the theme is active.

## Practical Theme Workflow

Use `settings.json` when you already know the theme you want every day. Use `/theme` when you are testing or presenting. Use `~/.gemini/themes/` when the built-in themes are close but not sufficient for your terminal, accessibility, or brand preferences.
