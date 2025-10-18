# Project: Quebec Retirement Planning Wizard

## Context
I want to update the retirement planning application for Quebec users with a unique hybrid wizard/todo-list interface. Please review these requirements and create a comprehensive implementation plan.

## Core Requirements

### User Experience Goals
- Serve inexperienced users who need guidance
- Allow users to stop/resume the lengthy process multiple times  
- Enable skipping sections to return to later
- Mix educational content with data collection
- Provide a persistent todo-list view with wizard-style guidance

### Key UI/UX Concept
A dual-panel interface where:
- Left panel: Smart todo list showing all sections, progress, and status
- Right panel: Current step content
- Users can either follow guided "Next" flow OR jump to any section
- Mobile: Collapsible bottom sheet for navigation

### Section Status System
- ✅ Complete
- 🔄 In Progress  
- ⏸️ Skipped for now
- ⏹️ Not started
- 📚 Educational (optional)
- ⚠️ Needs attention

## Your Task

1. **FIRST: Create an Implementation Plan**
   - Analyze these requirements
   - Propose the overall wizard steps (from the user standpoint)

2. **Present the Plan**
   Show me:
   - Development phases (with testing points)
   - Data model design
   - Key architectural decisions to discuss

3. **Wait for Approval**
   Before starting implementation, let's discuss your plan

## Constraints & Preferences
- Must support French/English from the start
- Must work on desktop and mobile
- Data persistence is critical (users will stop/resume)
- Should be production-ready architecture
- Follow best practices in @"specs/Design Best Practices.md" and in @"specs/UI Guidelines.md"
- The architecture is described in @"docs/ARCHITECTURE.md"
- Reuse data layer services to ensure consistency and maintainability
