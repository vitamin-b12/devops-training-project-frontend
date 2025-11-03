# ![React + Redux Example App](project-logo.png)

[![RealWorld Frontend](https://img.shields.io/badge/realworld-frontend-%23783578.svg)](http://realworld.io)

> ### React + Redux codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld-example-apps) spec and API.

This codebase demonstrates a fully fledged frontend application built with **React** and **Redux**, including authentication, routing, pagination, and more. It's a social blogging site (a Medium.com clone) called "Conduit" that implements the RealWorld API specification.

## Features

- **User Authentication**: JWT-based authentication with login, registration, and user settings
- **Article Management**: Create, read, update, and delete articles with markdown support
- **Comments**: Add and delete comments on articles
- **Social Features**: Favorite articles and follow other users
- **Pagination**: Efficient article listing with pagination
- **Tag System**: Filter articles by tags
- **User Profiles**: View user profiles and their articles/favorites

## Technology Stack

- **React 16.3** - UI library
- **Redux 3.6** - State management
- **React Router 4** - Client-side routing
- **Superagent** - HTTP client for API requests
- **Marked** - Markdown rendering
- **Create React App** - Build tooling and development server

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v12 or higher recommended)
- **npm** (v6 or higher) or **yarn**
- A backend API server running (see [Backend Configuration](#backend-configuration))

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd devops-training-project-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

### Running the Application Locally

Start the development server:

```bash
npm start
```

The application will start on **http://localhost:4100** (port 4100 is used instead of the default 3000 to avoid conflicts with backend servers).

The development server includes:
- Hot module replacement (HMR)
- Automatic browser refresh on code changes
- Source maps for debugging
- Error overlay in the browser

### Building for Production

To create a production build:

```bash
npm run build
```

This creates an optimized production build in the `build/` directory. The build is minified and ready for deployment.

To serve the production build locally:

```bash
npm install -g serve
serve -s build
```

### Running Tests

Run the test suite:

```bash
npm test
```

This runs tests in watch mode. Press `a` to run all tests, or `q` to quit watch mode.

### Backend Configuration

The frontend needs to connect to a backend API server. By default, it's configured to use the production API at `https://conduit.productionready.io/api`.

**To use a local backend server:**

1. Edit `src/agent.js` and change the `API_ROOT` constant:
   ```javascript
   const API_ROOT = 'http://localhost:8080';
   ```
   
   **Note**: The backend API should be available at `http://localhost:8080` (without `/api` prefix).

2. Alternatively, you can use environment variables by creating a `.env` file in the root directory:
   ```
   REACT_APP_API_ROOT=http://localhost:8080
   ```
   
   Then update `src/agent.js` to use:
   ```javascript
   const API_ROOT = process.env.REACT_APP_API_ROOT || 'https://conduit.productionready.io/api';
   ```

**Important**: Make sure your backend server is running and accessible before starting the frontend application.


## Architecture Overview

The frontend application follows a **component-based architecture** with **Redux** for state management, following the **Flux pattern** for unidirectional data flow.

### Architectural Patterns

#### Component-Based Architecture
The application is built using React's component-based architecture where:
- **Reusable Components**: UI is broken down into reusable, composable components
- **Container/Presentational Pattern**: Some components handle logic (containers) while others focus on presentation
- **Component Composition**: Complex UIs are built by composing simpler components

#### Flux/Redux Pattern
The application implements the Flux pattern via Redux for predictable state management:
- **Unidirectional Data Flow**: Data flows in one direction through the application
- **Single Source of Truth**: All application state is stored in a single Redux store
- **Predictable State Updates**: State changes are made through pure reducer functions

### Application Structure

The application follows a component-based architecture with Redux for state management:

```
src/
├── components/          # React components
│   ├── App.js          # Main application component with routing
│   ├── Header.js       # Navigation header
│   ├── Home/           # Home page components
│   │   ├── index.js   # Home container component
│   │   ├── Banner.js   # Hero banner
│   │   ├── MainView.js # Main article feed
│   │   └── Tags.js     # Tags sidebar
│   ├── Article/        # Article detail components
│   │   ├── index.js   # Article container
│   │   ├── ArticleMeta.js # Article metadata
│   │   ├── CommentList.js # Comments list
│   │   └── CommentInput.js # Comment input form
│   ├── Editor.js       # Article editor
│   ├── Login.js        # Login page
│   ├── Register.js     # Registration page
│   ├── Settings.js     # User settings
│   └── Profile.js      # User profile
├── reducers/           # Redux reducers
│   ├── auth.js         # Authentication state
│   ├── article.js      # Single article state
│   ├── articleList.js  # Article list state
│   ├── editor.js       # Editor state
│   ├── profile.js      # Profile state
│   └── settings.js     # Settings state
├── agent.js            # API client (HTTP requests)
├── store.js            # Redux store configuration
├── middleware.js       # Redux middleware
└── constants/          # Action type constants
    └── actionTypes.js  # Action type definitions
```

### Redux Architecture

The application uses **Redux** for centralized state management following the Flux pattern:

```
┌─────────────────────────────────────────┐
│         React Components               │
│    (User interactions trigger)         │
└─────────────────────────────────────────┘
                  ↓ dispatch(action)
┌─────────────────────────────────────────┐
│            Redux Store                  │
│      (Single source of truth)          │
└─────────────────────────────────────────┘
                  ↓ state changes
┌─────────────────────────────────────────┐
│           Reducers                     │
│   (Pure functions update state)        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         Middleware                      │
│   (API calls, logging, etc.)           │
└─────────────────────────────────────────┘
```

**Key Concepts**:
- **Store**: Single source of truth for application state
- **Actions**: Plain JavaScript objects describing what happened
- **Action Creators**: Functions that create and dispatch actions
- **Reducers**: Pure functions that take current state and action, return new state
- **Middleware**: Intercepts actions for side effects (API calls, logging)

### State Management Flow

#### Reading Data (Component → Store)
```
Component → connect() → mapStateToProps → Redux Store → Component receives props
```

#### Writing Data (Component → Store → API)
```
User Action → Component → dispatch(action) → Middleware → API Call → 
Reducer → Store Update → Component re-renders with new props
```

### Redux Store Structure

The Redux store is organized by feature domains:

```javascript
{
  auth: {
    currentUser: User | null,
    token: string | null
  },
  article: {
    article: Article | null,
    comments: Comment[]
  },
  articleList: {
    articles: Article[],
    articlesCount: number,
    currentPage: number
  },
  editor: {
    articleSlug: string | null,
    title: string,
    description: string,
    body: string,
    tagList: string[]
  },
  profile: {
    profile: Profile | null,
    articles: Article[]
  },
  settings: {
    // User settings form state
  },
  common: {
    appLoaded: boolean,
    appName: string,
    redirectTo: string | null
  },
  router: {
    // React Router state
  }
}
```

### Component Architecture Layers

```
┌─────────────────────────────────────────┐
│      Presentation Layer                │
│  (Presentational Components - UI only)  │
└─────────────────────────────────────────┘
                  ↓ props
┌─────────────────────────────────────────┐
│       Container Layer                   │
│  (Container Components - Logic + State) │
│  - Connect to Redux                     │
│  - Handle user actions                  │
│  - Dispatch actions                      │
└─────────────────────────────────────────┘
                  ↓ dispatch
┌─────────────────────────────────────────┐
│        State Layer                      │
│  (Redux Store + Reducers)              │
└─────────────────────────────────────────┘
                  ↓ API calls
┌─────────────────────────────────────────┐
│        Service Layer                    │
│  (agent.js - API client)               │
└─────────────────────────────────────────┘
```

### Authentication Flow

The authentication flow demonstrates the Redux pattern:

```
1. User submits login form
   ↓
2. Component dispatches LOGIN action
   ↓
3. Middleware intercepts LOGIN action
   ↓
4. API call via agent.js → POST /users/login
   ↓
5. Backend returns JWT token + user data
   ↓
6. Middleware dispatches LOGIN_SUCCESS action with payload
   ↓
7. Auth reducer updates state:
   - Sets currentUser
   - Stores token in localStorage
   ↓
8. Component receives updated props via mapStateToProps
   ↓
9. Component redirects to home page
```

**Token Management**:
- Token stored in `localStorage` for persistence
- Token added to all API requests via `agent.js` tokenPlugin
- Token validated on app load by calling `/user` endpoint

### Routing Architecture

The application uses **React Router** with **React Router Redux** for synchronized routing:

```
┌─────────────────────────────────────────┐
│        Browser URL                     │
│     /article/some-slug                 │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      React Router                       │
│  (Matches route to component)           │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Redux Router Reducer               │
│  (Updates router state in store)        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Component Renders                  │
│  (Article component loads)               │
└─────────────────────────────────────────┘
```

**Route Protection**:
- Public routes: `/`, `/login`, `/register`, `/article/:id`
- Protected routes: `/settings`, `/editor`, `/editor/:slug`
- Conditional rendering based on authentication state

### API Integration Architecture

All API calls are centralized in `src/agent.js` following a service layer pattern:

```
┌─────────────────────────────────────────┐
│      Components                       │
│  (Dispatch actions)                     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Redux Middleware                  │
│  (Intercepts API actions)              │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      agent.js                           │
│  (Centralized API client)               │
│  - Superagent HTTP client               │
│  - Token management                     │
│  - Request/response transformation     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Backend API                        │
│  (REST endpoints)                      │
└─────────────────────────────────────────┘
```

**API Client Organization**:
- `Auth` - Authentication endpoints (`/users`, `/users/login`, `/user`)
- `Articles` - Article CRUD (`/articles`, `/articles/:slug`)
- `Comments` - Comment operations (`/articles/:slug/comments`)
- `Profile` - Profile operations (`/profiles/:username`)
- `Tags` - Tag operations (`/tags`)

**Request Flow**:
1. Component dispatches action (e.g., `FETCH_ARTICLE`)
2. Middleware intercepts and calls `agent.Articles.get(slug)`
3. Superagent makes HTTP request with token
4. Response transformed and returned
5. Middleware dispatches success/failure action
6. Reducer updates state
7. Component re-renders with new data

### Data Flow Example: Loading Articles

```
1. User navigates to home page
   ↓
2. Home component mounts → dispatches FETCH_ARTICLES
   ↓
3. Middleware → agent.Articles.all(page)
   ↓
4. API call → GET /articles?limit=10&offset=0
   ↓
5. Backend returns: { articles: [...], articlesCount: 100 }
   ↓
6. Middleware dispatches ARTICLES_LOADED action
   ↓
7. articleList reducer updates state:
   { articles: [...], articlesCount: 100, currentPage: 0 }
   ↓
8. Home component receives updated articles via props
   ↓
9. Component re-renders with article list
```

### Component Communication Patterns

**Parent-Child Communication**:
- Props passed down from parent to child
- Callbacks passed down for child to communicate with parent

**Sibling Communication**:
- Both components connect to Redux store
- Share state through Redux store
- Dispatch actions to update shared state

**Cross-Component Communication**:
- All components connect to Redux store
- Actions dispatched affect multiple components
- Store acts as communication hub

## Application Pages

### Home Page (`/`)
- **Tags Sidebar**: Displays popular tags for filtering
- **Article Feed**: Shows articles from:
  - Global feed (all articles)
  - Your feed (articles from followed users) - requires authentication
  - Tag filter (articles with specific tag)
- **Pagination**: Navigate through article pages
- **Article Preview**: Shows article title, description, author, and metadata

### Authentication Pages

#### Login (`/login`)
- Email and password authentication
- Redirects to home page on success
- Stores JWT token in localStorage

#### Register (`/register`)
- User registration with username, email, and password
- Validates input and displays errors
- Automatically logs in user after registration

### Settings Page (`/settings`)
- **Protected Route**: Requires authentication
- Update user profile:
  - Email
  - Username
  - Password
  - Bio
  - Profile image URL
- Logout functionality

### Editor (`/editor` or `/editor/:slug`)
- **Protected Route**: Requires authentication
- Create new articles or edit existing ones
- Fields:
  - Article title
  - Description
  - Body (markdown supported)
  - Tags (comma-separated)
- Preview and publish functionality

### Article Detail (`/article/:id`)
- Full article display with markdown rendering
- Article metadata (author, date, favorites count)
- **Actions** (if authenticated):
  - Favorite/Unfavorite article
  - Follow/Unfollow author
  - Edit/Delete article (if author)
- **Comments Section**:
  - List all comments
  - Add new comment (requires authentication)
  - Delete comment (if comment author)

### Profile Pages

#### User Profile (`/@:username`)
- Display user information
- List of articles created by the user
- Follow/Unfollow button (if authenticated and not own profile)
- Pagination for article list

#### Favorited Articles (`/@:username/favorites`)
- Display user's favorited articles
- Pagination support

## Development

### Port Configuration

The application runs on port **4100** by default (configured in `package.json`). To change the port:

1. Edit `package.json` and modify the `start` script:
   ```json
   "start": "cross-env PORT=4100 react-scripts start"
   ```

2. Or create a `.env` file:
   ```
   PORT=4100
   ```

### Environment Variables

Create a `.env` file in the root directory for environment-specific configuration:

```
REACT_APP_API_ROOT=http://localhost:8080
PORT=4100
```

**Note**: Environment variables must be prefixed with `REACT_APP_` to be accessible in the application.

### Project Scripts

- `npm start` - Start development server
- `npm run build` - Create production build
- `npm test` - Run tests in watch mode
- `npm run eject` - Eject from Create React App (one-way operation)

### Code Structure

- **Components**: Presentational and container components
- **Reducers**: State management logic organized by feature
- **Agent**: Centralized API client with token management
- **Constants**: Action type definitions for Redux
- **Middleware**: Custom Redux middleware for API calls

<br />

[![Brought to you by Thinkster](https://raw.githubusercontent.com/gothinkster/realworld/master/media/end.png)](https://thinkster.io)
