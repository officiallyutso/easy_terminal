## [0.1.3] - 2025-06-25

### Added
- Documentation with proper implementation examples
---


## [0.1.2] - 2025-06-25

### Added
- `TerminalText` now supports `isBold` and color overrides
- `TerminalListSelector`: added callback for index on selection
- `TerminalPanel`: supports variable width/height and nested widgets
- New commands in example: `matrix`, `figlet`, `cowsay`, and `themes`
- `ThemeManager`: dynamic theme switching from command-line
- Custom ASCII renderer for simple figlet-style banners

### Changed
- Improved key handling in `TerminalInput` for smoother typing experience
- Refactored `TerminalViewState` to expose a clean API for output and theme changes
- Enhanced progress bar visuals and percentage formatting

### Fixed
- Terminal buffer scroll overflow issue
- Theme reset bug when clearing screen
- List selector edge case causing incorrect item selection on rapid input

---

## [0.0.1] - 2025-06-25

### Added
- Initial release of Easy Terminal
- TerminalView widget with full keyboard support
- Multiple terminal themes (CRT Green, Amber, Hacker Dark)
- Terminal components: panels, progress bars, list selectors, input prompts
- Box drawing characters and monospaced font rendering
- Command parsing and execution system
- Screen buffer management
- Comprehensive example application

### Features
- Full keyboard navigation
- Customizable themes
- Modular widget architecture
- Developer-friendly API
- Educational and gaming applications support
