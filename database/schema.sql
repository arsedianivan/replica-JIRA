-- JIRA Clone Database Schema
-- PostgreSQL 13+ compatible

-- Enable UUID extension for generating unique identifiers
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Organizations table for multi-tenancy (like JIRA Cloud)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    domain VARCHAR(255),
    logo_url TEXT,
    subscription_type VARCHAR(50) DEFAULT 'free', -- free, standard, premium
    max_users INTEGER DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Users table with JIRA-style profile data
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'member', -- admin, member, viewer
    is_active BOOLEAN DEFAULT true,
    timezone VARCHAR(100) DEFAULT 'UTC',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_username_per_org UNIQUE (organization_id, username)
);

-- Issue types (Story, Task, Bug, Epic with specific icons)
CREATE TABLE issue_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(100) NOT NULL, -- story, task, bug, epic
    color VARCHAR(7) NOT NULL, -- hex color code
    description TEXT,
    is_subtask_type BOOLEAN DEFAULT false,
    hierarchy_level INTEGER DEFAULT 0, -- 0=standard, -1=subtask, 1=epic
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_issue_type_per_org UNIQUE (organization_id, name)
);

-- Workflows with statuses and transitions
CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE workflow_statuses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- to_do, in_progress, done
    color VARCHAR(7) DEFAULT '#42526E',
    position INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE workflow_transitions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
    from_status_id UUID REFERENCES workflow_statuses(id),
    to_status_id UUID NOT NULL REFERENCES workflow_statuses(id),
    name VARCHAR(255) NOT NULL,
    is_initial BOOLEAN DEFAULT false, -- for creating new issues
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects with JIRA-style keys and metadata
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    key VARCHAR(10) UNIQUE NOT NULL, -- PROJ, TEST, etc.
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(100) DEFAULT 'project',
    category VARCHAR(100) DEFAULT 'software',
    lead_id UUID REFERENCES users(id),
    workflow_id UUID NOT NULL REFERENCES workflows(id),
    default_assignee_id UUID REFERENCES users(id),
    issue_counter INTEGER DEFAULT 0,
    is_private BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sprints with lifecycle management
CREATE TABLE sprints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    goal TEXT,
    state VARCHAR(20) DEFAULT 'future', -- future, active, closed
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comprehensive issues table with all JIRA fields
CREATE TABLE issues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    key VARCHAR(20) UNIQUE NOT NULL, -- PROJECT-123 format
    issue_type_id UUID NOT NULL REFERENCES issue_types(id),
    parent_id UUID REFERENCES issues(id), -- for subtasks
    epic_id UUID REFERENCES issues(id), -- epic link
    summary VARCHAR(500) NOT NULL,
    description TEXT,
    current_status_id UUID NOT NULL REFERENCES workflow_statuses(id),
    priority VARCHAR(20) DEFAULT 'Medium', -- Highest, High, Medium, Low, Lowest
    reporter_id UUID NOT NULL REFERENCES users(id),
    assignee_id UUID REFERENCES users(id),
    sprint_id UUID REFERENCES sprints(id),
    story_points INTEGER,
    time_estimate INTEGER, -- in seconds
    time_spent INTEGER DEFAULT 0, -- in seconds
    remaining_estimate INTEGER, -- in seconds
    resolution VARCHAR(100), -- Done, Won't Do, Duplicate, etc.
    resolved_at TIMESTAMP WITH TIME ZONE,
    due_date DATE,
    labels TEXT[], -- array of labels
    custom_fields JSONB DEFAULT '{}', -- flexible custom fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments with rich text support
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES users(id),
    content TEXT NOT NULL, -- rich text in Atlassian Document Format or HTML
    is_internal BOOLEAN DEFAULT false, -- for internal comments
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attachments
CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
    uploader_id UUID NOT NULL REFERENCES users(id),
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size INTEGER NOT NULL,
    file_path TEXT NOT NULL, -- S3 path or local file path
    thumbnail_path TEXT, -- for images
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Issue history for activity feed
CREATE TABLE issue_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    action VARCHAR(50) NOT NULL, -- created, updated, transitioned, commented, etc.
    field_name VARCHAR(100), -- what field was changed
    old_value TEXT, -- JSON string of old value
    new_value TEXT, -- JSON string of new value
    description TEXT, -- human readable description
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Project permissions and memberships
CREATE TABLE project_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'developer', -- admin, developer, viewer
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_project_member UNIQUE (project_id, user_id)
);

-- Issue watchers
CREATE TABLE issue_watchers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_issue_watcher UNIQUE (issue_id, user_id)
);

-- Custom field definitions
CREATE TABLE custom_fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    field_type VARCHAR(50) NOT NULL, -- text, number, select, multiselect, date, user, etc.
    description TEXT,
    is_required BOOLEAN DEFAULT false,
    options JSONB, -- for select/multiselect fields
    default_value TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Link custom fields to projects
CREATE TABLE project_custom_fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    custom_field_id UUID NOT NULL REFERENCES custom_fields(id) ON DELETE CASCADE,
    is_required BOOLEAN DEFAULT false,
    position INTEGER DEFAULT 0,
    CONSTRAINT unique_project_custom_field UNIQUE (project_id, custom_field_id)
);

-- Indexes for performance
CREATE INDEX idx_users_organization_id ON users(organization_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_projects_organization_id ON projects(organization_id);
CREATE INDEX idx_projects_key ON projects(key);
CREATE INDEX idx_issues_project_id ON issues(project_id);
CREATE INDEX idx_issues_key ON issues(key);
CREATE INDEX idx_issues_assignee_id ON issues(assignee_id);
CREATE INDEX idx_issues_reporter_id ON issues(reporter_id);
CREATE INDEX idx_issues_sprint_id ON issues(sprint_id);
CREATE INDEX idx_issues_current_status_id ON issues(current_status_id);
CREATE INDEX idx_issues_created_at ON issues(created_at);
CREATE INDEX idx_comments_issue_id ON comments(issue_id);
CREATE INDEX idx_issue_history_issue_id ON issue_history(issue_id);
CREATE INDEX idx_issue_history_created_at ON issue_history(created_at);
CREATE INDEX idx_attachments_issue_id ON attachments(issue_id);

-- Trigger to auto-increment issue counter and generate issue keys
CREATE OR REPLACE FUNCTION generate_issue_key()
RETURNS TRIGGER AS $$
BEGIN
    -- Increment the project's issue counter
    UPDATE projects 
    SET issue_counter = issue_counter + 1 
    WHERE id = NEW.project_id;
    
    -- Generate the issue key
    SELECT CONCAT(p.key, '-', p.issue_counter)
    INTO NEW.key
    FROM projects p
    WHERE p.id = NEW.project_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generate_issue_key
    BEFORE INSERT ON issues
    FOR EACH ROW
    WHEN (NEW.key IS NULL)
    EXECUTE FUNCTION generate_issue_key();

-- Trigger to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sprints_updated_at BEFORE UPDATE ON sprints FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_issues_updated_at BEFORE UPDATE ON issues FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();