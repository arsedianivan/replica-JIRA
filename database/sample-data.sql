-- Sample data for JIRA Clone Database
-- Run this after schema.sql to populate with test data

-- Insert sample organization
INSERT INTO organizations (id, name, slug, domain, subscription_type) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Acme Corporation', 'acme-corp', 'acme.com', 'premium');

-- Insert sample users
INSERT INTO users (id, organization_id, email, username, display_name, avatar_url, password_hash, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'admin@acme.com', 'admin', 'John Admin', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', '$2b$10$hashedpassword1', 'admin'),
('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'alice@acme.com', 'alice.smith', 'Alice Smith', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice', '$2b$10$hashedpassword2', 'member'),
('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', 'bob@acme.com', 'bob.johnson', 'Bob Johnson', 'https://api.dicebear.com/7.x/avataaars/svg?seed=bob', '$2b$10$hashedpassword3', 'member'),
('550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440000', 'carol@acme.com', 'carol.wilson', 'Carol Wilson', 'https://api.dicebear.com/7.x/avataaars/svg?seed=carol', '$2b$10$hashedpassword4', 'member');

-- Insert JIRA-style issue types
INSERT INTO issue_types (id, organization_id, name, icon, color, description, hierarchy_level) VALUES
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440000', 'Epic', 'epic', '#6554C0', 'Large feature or initiative', 1),
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440000', 'Story', 'story', '#00875A', 'User story or feature requirement', 0),
('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440000', 'Task', 'task', '#0052CC', 'Work item or task to be completed', 0),
('550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440000', 'Bug', 'bug', '#DE350B', 'Software bug or defect', 0),
('550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440000', 'Sub-task', 'subtask', '#4C9AFF', 'Subtask of another issue', -1);

-- Insert default workflow
INSERT INTO workflows (id, organization_id, name, description, is_default) VALUES
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440000', 'Software Development Workflow', 'Standard software development workflow', true);

-- Insert workflow statuses
INSERT INTO workflow_statuses (id, workflow_id, name, category, color, position) VALUES
('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440020', 'To Do', 'to_do', '#42526E', 1),
('550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440020', 'In Progress', 'in_progress', '#0052CC', 2),
('550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440020', 'In Review', 'in_progress', '#FF8B00', 3),
('550e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440020', 'Done', 'done', '#00875A', 4);

-- Insert workflow transitions
INSERT INTO workflow_transitions (workflow_id, from_status_id, to_status_id, name, is_initial) VALUES
('550e8400-e29b-41d4-a716-446655440020', NULL, '550e8400-e29b-41d4-a716-446655440021', 'Create Issue', true),
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440022', 'Start Progress'),
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440023', 'Submit for Review'),
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440024', 'Approve'),
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440022', 'Request Changes'),
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440021', 'Stop Progress');

-- Insert sample project
INSERT INTO projects (id, organization_id, key, name, description, icon, category, lead_id, workflow_id, issue_counter) VALUES
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440000', 'DEMO', 'Demo Project', 'Sample project for testing JIRA clone functionality', 'project', 'software', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440020', 5);

-- Add project members
INSERT INTO project_members (project_id, user_id, role) VALUES
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440001', 'admin'),
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440002', 'developer'),
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440003', 'developer'),
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440004', 'developer');

-- Insert sample sprint
INSERT INTO sprints (id, project_id, name, goal, state, start_date, end_date) VALUES
('550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440030', 'Sprint 1', 'Complete initial project setup and basic features', 'active', '2024-01-01 09:00:00+00', '2024-01-14 17:00:00+00');

-- Insert sample issues
INSERT INTO issues (id, project_id, key, issue_type_id, summary, description, current_status_id, priority, reporter_id, assignee_id, sprint_id, story_points, labels) VALUES
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440030', 'DEMO-1', '550e8400-e29b-41d4-a716-446655440010', 'User Authentication System', 'Implement complete user authentication system with login, registration, and password reset', '550e8400-e29b-41d4-a716-446655440022', 'High', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440040', 13, ARRAY['authentication', 'backend']),

('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440030', 'DEMO-2', '550e8400-e29b-41d4-a716-446655440011', 'User Login Page', 'Create responsive login page with email/password form and validation', '550e8400-e29b-41d4-a716-446655440021', 'Medium', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440040', 5, ARRAY['frontend', 'ui']),

('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440030', 'DEMO-3', '550e8400-e29b-41d4-a716-446655440013', 'Login validation not working on mobile', 'Email validation fails on mobile devices when using certain keyboards', '550e8400-e29b-41d4-a716-446655440023', 'High', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440040', 3, ARRAY['bug', 'mobile', 'frontend']),

('550e8400-e29b-41d4-a716-446655440053', '550e8400-e29b-41d4-a716-446655440030', 'DEMO-4', '550e8400-e29b-41d4-a716-446655440012', 'Setup CI/CD Pipeline', 'Configure automated testing and deployment pipeline using GitHub Actions', '550e8400-e29b-41d4-a716-446655440021', 'Medium', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440040', 8, ARRAY['devops', 'automation']),

('550e8400-e29b-41d4-a716-446655440054', '550e8400-e29b-41d4-a716-446655440030', 'DEMO-5', '550e8400-e29b-41d4-a716-446655440011', 'Dashboard Overview Page', 'Create main dashboard with project overview, recent activity, and quick actions', '550e8400-e29b-41d4-a716-446655440024', 'Low', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', NULL, 8, ARRAY['frontend', 'dashboard']);

-- Set epic link
UPDATE issues SET epic_id = '550e8400-e29b-41d4-a716-446655440050' 
WHERE key IN ('DEMO-2', 'DEMO-3');

-- Insert sample comments
INSERT INTO comments (issue_id, author_id, content) VALUES
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440004', 'I can reproduce this on iPhone Safari. The email input seems to lose focus when the @ symbol is entered.'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440003', 'Thanks for reporting! I''ll investigate the mobile keyboard handling. Might need to adjust the input event listeners.'),
('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440002', 'I''ve started working on the mockups. Should have the initial design ready by tomorrow.'),
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440001', 'This epic covers all the authentication work for the first release. Priority items are login/logout and JWT handling.');

-- Insert sample issue history
INSERT INTO issue_history (issue_id, user_id, action, field_name, old_value, new_value, description) VALUES
('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440002', 'created', NULL, NULL, NULL, 'Issue created'),
('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440002', 'updated', 'assignee', NULL, '550e8400-e29b-41d4-a716-446655440003', 'Assignee changed to Bob Johnson'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440003', 'transitioned', 'status', 'To Do', 'In Review', 'Status changed from To Do to In Review'),
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440001', 'updated', 'priority', 'Medium', 'High', 'Priority changed from Medium to High'),
('550e8400-e29b-41d4-a716-446655440054', '550e8400-e29b-41d4-a716-446655440004', 'transitioned', 'status', 'In Progress', 'Done', 'Status changed from In Progress to Done');

-- Insert custom field definition
INSERT INTO custom_fields (id, organization_id, name, field_type, description, options) VALUES
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440000', 'Browser Version', 'select', 'Browser version for bug reports', '{"options": ["Chrome 120+", "Firefox 121+", "Safari 17+", "Edge 120+", "Other"]}');

-- Link custom field to project
INSERT INTO project_custom_fields (project_id, custom_field_id, is_required, position) VALUES
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440060', false, 1);

-- Add custom field data to bug issue
UPDATE issues 
SET custom_fields = '{"Browser Version": "Safari 17+"}'
WHERE key = 'DEMO-3';

-- Insert issue watchers
INSERT INTO issue_watchers (issue_id, user_id) VALUES
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440001'),
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440002'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440001'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440003'),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440004');