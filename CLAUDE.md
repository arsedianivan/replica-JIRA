# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a JIRA replication project in its initial stages. The repository currently contains minimal setup with only basic documentation files.

## Current State

- **Project Type**: JIRA clone/replication challenge
- **Development Stage**: Initial setup (no source code yet)
- **License**: MIT License

## Development Setup

The project does not yet have a defined technology stack or build system. When implementing:

1. Choose appropriate technology stack based on requirements
2. Set up proper project structure and configuration files
3. Implement standard development commands (build, test, lint, dev server)
4. Update this CLAUDE.md file with specific commands and architecture details

## Next Steps

This project appears to be a starting point for building a JIRA replica. Key areas to establish:

- Technology stack selection (frontend/backend frameworks)
- Database design and setup  
- Project structure and configuration
- Development workflow and commands
- Testing strategy

## Notes

Update this file as the project evolves to include:
- Specific build/test/lint commands
- Architecture patterns and key components
- Database schema and data flow
- API structure and conventions

# JIRA Clone Project

## UI Requirements - EXACT JIRA REPLICATION
We are building an exact visual clone of JIRA with:

### Navigation Structure
- Top blue navigation bar (#0052CC background)
- White JIRA logo on left
- Navigation items: Projects, Filters, Dashboards, Teams, Apps, Create button
- Search bar in center
- Help, Settings, Profile avatar on right

### Left Sidebar (250px width)
- Project name and icon at top
- Navigation sections:
  - Planning: Roadmap, Backlog, Board, Reports
  - Development: Code, Releases
  - Operations: Issues, Components
- Project settings at bottom

### Main Board View
- Board header with title, star button, share button
- Sprint information bar
- Quick filters
- Columns: TO DO, IN PROGRESS, IN REVIEW, DONE
- Issue cards with:
  - Issue type icon (Story=green, Bug=red, Task=blue)
  - Issue key (PROJ-123)
  - Summary text
  - Priority flag icon
  - Story points in gray circle
  - Assignee avatar (bottom right)

### Issue Detail Panel
- Slides in from right (600px width)
- Breadcrumb navigation
- Issue type and key as header
- Editable title
- Description with rich text editor
- Right sidebar with: Status, Assignee, Reporter, Priority, Labels, Sprint
- Activity section with comments and history

### Color Scheme
- Primary blue: #0052CC
- Background: #FAFBFC
- Card background: #FFFFFF
- Text primary: #172B4D
- Text secondary: #5E6C84
- Borders: #DFE1E6

## Tech Stack
- Frontend: React 18 with TypeScript
- UI Framework: Atlaskit (JIRA's component library) or custom styled-components
- Backend: Node.js with Express
- Database: PostgreSQL
- Real-time: Socket.io
- State Management: Redux Toolkit
- Authentication: JWT with refresh tokens

## Code Standards
- Match JIRA's exact spacing (8px grid system)
- Use JIRA's font stack: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto
- All interactive elements must have hover states
- Loading skeletons for async data
- Keyboard shortcuts for power users