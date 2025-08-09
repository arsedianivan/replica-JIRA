# Database Schema

This directory contains the PostgreSQL database schema for the JIRA clone project.

## Files

- `schema.sql` - Complete database schema with all tables, indexes, and triggers
- `sample-data.sql` - Sample data for testing and development
- `README.md` - This documentation file

## Setup

1. Create a PostgreSQL database:
   ```sql
   CREATE DATABASE jira_clone;
   ```

2. Run the schema file:
   ```bash
   psql -d jira_clone -f database/schema.sql
   ```

3. Load sample data (optional):
   ```bash
   psql -d jira_clone -f database/sample-data.sql
   ```

## Key Features

### JIRA-Specific Implementation
- **Issue Keys**: Automatic generation in PROJECT-123 format
- **Priority Levels**: Highest, High, Medium, Low, Lowest
- **Multi-tenancy**: Organization-based data isolation
- **Custom Fields**: JSONB support for flexible field definitions
- **Epic Links**: Parent-child relationships between issues
- **Subtasks**: Hierarchical issue relationships

### Database Schema Highlights
- UUID primary keys for better scalability
- Comprehensive indexing for performance
- Audit trail via `issue_history` table
- Rich text support for comments and descriptions
- File attachment management
- Sprint lifecycle management
- Flexible workflow system with statuses and transitions

### Performance Optimizations
- Strategic indexes on frequently queried columns
- Efficient foreign key relationships
- Optimized for common JIRA queries (by project, assignee, status, sprint)

## Sample Data Overview

The sample data includes:
- 1 organization (Acme Corporation)
- 4 users with different roles
- 1 project (DEMO) with standard JIRA issue types
- 1 active sprint
- 5 sample issues including Epic, Story, Task, and Bug
- Comments and issue history
- Custom fields example
- Workflow with 4 standard statuses

## Environment Variables

When connecting to the database, you'll need:
```
DATABASE_URL=postgresql://username:password@localhost:5432/jira_clone
```