# Refactoring Strategy for Trilium Notes

This document outlines a strategy for refactoring the Trilium Notes application to improve its maintainability, scalability, and developer experience. The key areas of focus are migrating to TypeScript, applying SOLID principles, introducing plugin development tooling, and considering an editor replacement.

## 1. TypeScript Migration

Migrating the existing JavaScript codebase to TypeScript will bring benefits like static typing, improved code navigation, easier refactoring, and early error detection.

### 1.1. Phased Approach

A full migration will be a significant effort. A phased approach is recommended:

1.  **Setup TypeScript Environment:**
    *   Add TypeScript as a dev dependency: `npm install --save-dev typescript @types/node @types/express @types/jquery @types/react @types/react-dom @types/marked @types/sanitize-html @types/archiver @types/better-sqlite3 @types/ws @types/fs-extra` (and other relevant @types for major dependencies).
    *   Create `tsconfig.json` with appropriate settings (e.g., `target: "es2018"`, `module: "commonjs"`, `strict: true` (or start with `false` and incrementally enable stricter checks), `esModuleInterop: true`, `sourceMap: true`, `outDir: "dist"` (or keep JS files alongside TS initially with `allowJs: true` and `checkJs: true` for gradual migration)).
    *   Integrate TypeScript compilation into the build process (e.g., update `webpack.config.js` or add npm scripts using `tsc`).
2.  **Start with New Code:** Write all new features and modules in TypeScript.
3.  **Migrate Utility Modules:** Convert small, self-contained utility modules first (e.g., in `src/services/utils.js` or similar helper files). This will help build experience with TypeScript in this codebase.
4.  **Migrate Core Services:** Gradually migrate core services in `src/services/`. This will likely be the most complex part.
5.  **Migrate Routes and API Handlers:** Convert files in `src/routes/`.
6.  **Migrate Frontend Code:** Convert frontend JavaScript files in `src/public/app/`. This will involve React components, so JSX syntax (`"jsx": "react"` in `tsconfig.json`) will be needed.
7.  **Migrate Becca Entities:** Convert files in `src/becca/entities/`.
8.  **Migrate Main Entry Points:** Finally, migrate `src/app.js`, `electron.js`, and `src/www.js`.

### 1.2. Essential Types and Interfaces

Define core types and interfaces early in the process. These can be placed in a `types/` directory or alongside relevant modules. Examples:

*   `Note.ts`: Interface for the note structure.
*   `Attribute.ts`: Interface for note attributes.
*   `User.ts`: Interface for user data.
*   `APITypes.ts`: Interfaces for common API request and response payloads.
*   `ServiceInterfaces.ts`: Interfaces for service contracts.

### 1.3. Tooling
    *   Use ESLint with TypeScript support (`@typescript-eslint/parser`, `@typescript-eslint/eslint-plugin`) for linting.
    *   Use Prettier for consistent code formatting.

## 2. SOLID Principles Application

Applying SOLID principles will help in creating a more modular, flexible, and maintainable codebase.

*   **Single Responsibility Principle (SRP):**
    *   **Current State:** Some services in `src/services/` might handle multiple responsibilities. For example, a single service might manage note creation, data fetching, and also synchronization logic.
    *   **Refactoring:** Break down large services into smaller, more focused ones. For instance, `src/services/notes.js` could be split into `NoteCRUDService`, `NoteSearchService`, `NoteSyncService`, etc. Route handlers should primarily delegate to services rather than containing complex business logic.
*   **Open/Closed Principle (OCP):**
    *   **Current State:** Adding new note types or attribute types might require modifying existing core files.
    *   **Refactoring:** Design systems (e.g., note type registration, attribute handling) to be extensible via plugins or a more abstract registration mechanism, rather than direct code modification. Use strategy patterns or similar for varying behaviors.
*   **Liskov Substitution Principle (LSP):**
    *   **Current State:** If class hierarchies exist (e.g., for different note types or UI widgets), ensure subtypes are truly substitutable for their base types.
    *   **Refactoring:** When migrating to TypeScript, define clear interfaces for base types and ensure derived classes adhere strictly to these contracts.
*   **Interface Segregation Principle (ISP):**
    *   **Current State:** Large service classes might expose overly broad interfaces to clients that only need a subset of their functionality.
    *   **Refactoring:** Define smaller, role-specific interfaces. Clients should depend on interfaces that only expose the methods they need. For example, a `NoteRenderer` might only need a `getNoteContent(noteId)` method, not the full suite of note management methods.
*   **Dependency Inversion Principle (DIP):**
    *   **Current State:** High-level modules might directly depend on low-level modules/concrete implementations.
    *   **Refactoring:** Introduce abstractions (interfaces) for dependencies. High-level modules should depend on these abstractions, and low-level modules should implement them. Use dependency injection (DI) frameworks or manual DI to provide concrete implementations at runtime. This will improve testability (e.g., mocking services).

## 3. Plugin Development Tooling

Enhancing scripting capabilities with a more robust plugin system can significantly extend Trilium's functionality.

### 3.1. Plugin Architecture

*   **Extension Points:** Identify key areas where plugins can interact (e.g., new note types, custom renderers, backend event listeners, new API endpoints, custom widgets, theme customization).
*   **Plugin API:** Define a clear and stable API for plugins. This API should provide access to relevant Trilium functionalities (e.g., CRUD operations for notes, UI manipulation) in a controlled manner. This would build upon existing `BackendScriptApi.js` and `FrontendScriptApi.js`.
*   **Manifest File:** Each plugin should have a manifest file (`plugin.json`) declaring its name, version, author, permissions, and the extension points it uses.
*   **Lifecycle Management:** Implement mechanisms for installing, uninstalling, enabling, and disabling plugins.
*   **Sandboxing (Optional but Recommended):** For security, consider sandboxing plugin code execution, especially for frontend plugins.

### 3.2. Suggested Tools

*   **CLI for Plugin Development:** A command-line tool (`trilium-plugin-cli` or similar) could help scaffold new plugins, package them, and manage local development.
*   **Documentation:** Comprehensive documentation for the plugin API and development process.
*   **Marketplace/Registry (Future):** A place for users to discover and share plugins.

### 3.3. Leveraging Existing Scripting

The current scripting capabilities (documented in the Wiki) are a good foundation. The new plugin system should aim to formalize and extend these capabilities, providing better structure, discoverability, and management.

## 4. Editor Replacement (Monaco Editor)

The current application uses CKEditor for WYSIWYG and CodeMirror for code notes. Replacing these with the Monaco Editor (used in VS Code) could offer a more consistent and powerful editing experience, especially for code-heavy notes or for users familiar with VS Code.

### 4.1. Feasibility Evaluation

*   **Feature Parity:**
    *   **WYSIWYG:** Monaco is primarily a code editor. Achieving full WYSIWYG parity with CKEditor for rich text notes would be a significant challenge and might require integrating Monaco with another library or extensive custom development. This aspect needs careful consideration.
    *   **Code Editing:** Monaco excels here and would likely offer superior features compared to CodeMirror (better IntelliSense, more languages, diffing, etc.).
*   **Integration Complexity:**
    *   Identify all areas where CKEditor and CodeMirror are used (e.g., note editor widgets, markdown preview rendering if it relies on the editor's HTML).
    *   Monaco is a substantial library. Assess its impact on bundle size and performance.
*   **Licensing:** Monaco Editor is MIT licensed, which is compatible.

### 4.2. Integration Steps (if deemed feasible, focusing on code notes first)

1.  **Proof of Concept:** Start by replacing CodeMirror for a specific code note type with Monaco Editor in a separate branch.
2.  **Core Integration:**
    *   Develop a wrapper component for Monaco Editor.
    *   Handle loading/saving content, theme changes, and basic editor configurations.
    *   Integrate language support for common note types (JavaScript, Python, CSS, HTML, Markdown, etc.).
3.  **Feature Integration:**
    *   Implement features currently supported by CodeMirror (e.g., keybindings, search, linting if any).
    *   Explore advanced Monaco features like IntelliSense (might require language servers or basic setup), minimap, etc.
4.  **WYSIWYG (Major Challenge):**
    *   If pursuing Monaco for WYSIWYG, research how to enable rich text editing. This might involve building a custom layer on top of Monaco or using it in a hybrid way. This is the most uncertain part and might lead to a decision to keep CKEditor for WYSIWYG notes.
    *   Alternatively, improve Markdown editing with Monaco and have a live preview, rather than direct WYSIWYG in Monaco.

### 4.3. Potential Benefits

*   **Modern Code Editing:** Superior experience for code notes.
*   **Extensibility:** Monaco's API is rich and could allow for deeper integration with Trilium's features.
*   **Developer Familiarity:** Many developers are already familiar with the VS Code editing experience.

### 4.4. Recommendation

*   Prioritize replacing **CodeMirror with Monaco** for code-based note types first, as this offers clear benefits and is more straightforward.
*   The replacement of **CKEditor with Monaco for WYSIWYG** is a much larger and riskier task. It might be more practical to keep CKEditor for rich text notes or explore enhancing the Markdown editing experience with Monaco and a separate preview panel.

## 5. Overall Approach

1.  **Documentation & Understanding (Ongoing):** Continue to deepen understanding of the existing codebase as refactoring progresses.
2.  **Incremental Changes:** Apply these strategies incrementally. Avoid a "big bang" refactor.
3.  **Testing:** Ensure high test coverage throughout the refactoring process. TypeScript can help, but unit and integration tests are still crucial.
4.  **Community Feedback:** If applicable, involve the community in discussions about these changes, especially regarding plugin APIs or editor experiences.

This strategy provides a roadmap for modernizing the Trilium Notes codebase. Each major section (TypeScript, SOLID, Plugins, Editor) represents a significant project in itself and should be broken down further into smaller, manageable tasks.
