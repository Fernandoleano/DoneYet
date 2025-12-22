# DoneYet 🚀

> **A modern mission control system for teams** - Transform your meetings into actionable missions with real-time tracking, automation, and seamless integrations.

![Command Center](/.github/images/command_center.png)

## 🎯 About This Startup

DoneYet is a next-generation task management and meeting coordination platform designed for high-performing teams. It transforms traditional meetings into "briefings" where missions are created, assigned, and tracked in real-time - think of it as your team's command center.

### The Problem We're Solving

- **Meeting fatigue**: Too many meetings, not enough action
- **Lost tasks**: Action items get forgotten after meetings end
- **Poor accountability**: No clear ownership or tracking
- **Manual follow-ups**: Constant reminders and check-ins

### Our Solution

DoneYet provides a **military-inspired mission control interface** where:

- 📋 Meetings become "briefings"
- 🎯 Tasks become "missions"
- 👥 Team members are "agents"
- 🚀 Everything is tracked in your personal "Command Center"

---

## ✨ Key Features

### 🎮 Command Center Dashboard

Your personalized mission control hub showing:

- **Live Operations** - Active briefings in progress
- **Escalations** - Overdue missions requiring attention
- **Activity Overview** - Real-time statistics (briefings, dispatched, in progress, overdue)
- **Recent Briefings** - Quick access to all meetings

![Dashboard](/.github/images/dashboard.png)

### 📝 Smart Meeting Management

- Create briefings with custom titles
- Real-time mission capture during meetings
- Assign missions to team members on-the-fly
- Set due dates and priorities
- Dispatch all missions with one click

### 🤖 Visual Automation Builder

**Drag-and-drop workflow automation** - No code required!

![Automation Builder](/.github/images/automation_builder.png)

Build automations by dragging blocks:

- **Triggers**: Schedule (daily/weekly/monthly), Events
- **Actions**: Create Meeting, Send Email, Send Slack, Send Reminder
- **Configure** each block with custom parameters
- **Save** workflows as JSON automatically

### 🔔 Smart Notifications

- Real-time notification bell with badge counts
- Pending missions overview
- Overdue mission alerts
- Clickable notifications to view details

### 👥 Team Management

- Invite team members via email
- Role-based access (Captain/Agent)
- Workspace management
- Profile customization with avatars

### ⚙️ Settings & Customization

- **Profile Settings**: Update name, email, profile picture
- **Workspace Settings**: Customize workspace name
- **Account Management**: Password reset, sign out
- **Avatar Upload**: Active Storage integration for profile pictures

### 🔐 Authentication & Security

- Secure sign up/sign in with password encryption
- "Remember me" functionality with persistent cookies
- Session management
- Rate limiting on login attempts

---

## 🛠️ Tech Stack

### Backend

- **Ruby on Rails 8.1** - Modern web framework
- **PostgreSQL** - Robust database
- **Active Storage** - File uploads (avatars)
- **Active Record** - ORM with associations

### Frontend

- **Hotwire (Turbo + Stimulus)** - Reactive UI without heavy JavaScript
- **Tailwind CSS** - Utility-first styling
- **Vanilla JavaScript** - Drag-and-drop automation builder
- **ERB Templates** - Server-side rendering

### Key Gems & Libraries

- `bcrypt` - Password encryption
- `authentication-zero` - Modern Rails authentication
- `tailwindcss-rails` - CSS framework integration

---

## 📊 Database Schema

### Core Models

```ruby
# User (Agents & Captains)
- name, email_address, password_digest
- role (enum: agent, captain)
- workspace_id
- avatar (Active Storage attachment)

# Workspace
- name
- subscription_status (enum: trial, active, past_due, canceled)
- has_many :users, :meetings, :missions, :automations

# Meeting (Briefings)
- title, status (enum: briefing, dispatched)
- captain_id (User)
- workspace_id
- has_many :missions

# Mission
- title, due_at
- status (enum: pending, done, canceled)
- agent_id (User)
- meeting_id

# Automation
- name, automation_type (enum: recurring_meeting, reminder_schedule, integration_trigger)
- config (JSON)
- enabled (boolean)
- next_run_at, last_run_at
```

---

## 🎨 UI/UX Highlights

### Design Philosophy

- **Dark theme** with vibrant accent colors (indigo, purple, emerald)
- **Glassmorphism** effects with backdrop blur
- **Micro-animations** for enhanced user experience
- **Responsive design** - Works on all devices
- **Accessibility** - Semantic HTML, proper ARIA labels

### Color Palette

- Background: `#0f172a` (slate-900)
- Cards: `#1e293b` (slate-800)
- Primary: `#6366f1` (indigo-600)
- Success: `#10b981` (emerald-500)
- Warning: `#f59e0b` (amber-500)
- Danger: `#ef4444` (red-500)

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.2+
- Rails 8.1+
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/Fernandoleano/DoneYet.git
cd DoneYet
```

2. **Install dependencies**

```bash
bundle install
npm install
```

3. **Setup database**

```bash
rails db:create
rails db:migrate
```

4. **Start the server**

```bash
bin/dev
```

5. **Visit** `http://localhost:3000`

---

## 📸 Screenshots

### Sign Up / Sign In

Beautiful authentication pages with custom workspace creation

### Command Center

![Command Center](/.github/images/command_center.png)

### Meeting Briefing

Real-time mission capture with live status indicators

### Automation Builder

![Automation Builder](/.github/images/automation_builder.png)

### Notifications

Smart notification system with pending/overdue mission tracking

---

## 🗺️ Roadmap

### Phase 1 (Current) ✅

- [x] Core authentication system
- [x] Meeting/mission management
- [x] Command center dashboard
- [x] Team management
- [x] Visual automation builder
- [x] Notifications system

### Phase 2 (In Progress) 🚧

- [ ] Slack integration
- [ ] Email notifications
- [ ] Automation execution engine
- [ ] Analytics dashboard
- [ ] Mobile app

### Phase 3 (Planned) 📋

- [ ] AI-powered mission suggestions
- [ ] Voice-to-mission transcription
- [ ] Calendar integrations (Google, Outlook)
- [ ] Advanced reporting
- [ ] API for third-party integrations

---

## 👨‍💻 Development

### Running Tests

```bash
bundle exec rspec
```

### Code Style

- Follow Ruby Style Guide
- Use Rubocop for linting
- Write descriptive commit messages

### Contributing

This is a startup project, but contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📝 License

This project is proprietary software. All rights reserved.

---

## 🙏 Acknowledgments

Built with ❤️ by **Fernando Leano**

Special thanks to:

- Ruby on Rails community
- Tailwind CSS team
- Hotwire/Stimulus creators

---

## 📧 Contact

**Fernando Leano**

- GitHub: [@Fernandoleano](https://github.com/Fernandoleano)
- Email: fernandoleano4@gmail.com

---

<div align="center">
  <strong>DoneYet - Get It Done, Track It Better</strong>
  <br>
  <sub>Built with Ruby on Rails 🚀</sub>
</div>
