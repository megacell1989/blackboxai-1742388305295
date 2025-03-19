# Contributing to POS System

We love your input! We want to make contributing to POS System as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github
We use Github to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [Github Flow](https://guides.github.com/introduction/flow/index.html)
Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License
In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using Github's [issue tracker](https://github.com/yourusername/pos-system/issues)
We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/yourusername/pos-system/issues/new); it's that easy!

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can.
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Development Process

1. Clone the repository
\`\`\`bash
git clone https://github.com/yourusername/pos-system.git
cd pos-system
\`\`\`

2. Install dependencies
\`\`\`bash
npm run install:all
\`\`\`

3. Set up environment variables
\`\`\`bash
cp backend/.env.example backend/.env
# Edit .env with your configuration
\`\`\`

4. Set up the database
\`\`\`bash
npm run db:migrate
npm run seed
\`\`\`

5. Start development server
\`\`\`bash
npm run dev
\`\`\`

## Testing

We use Jest for testing. Run the test suite with:

\`\`\`bash
npm test
\`\`\`

Make sure to write tests for new features and ensure all tests pass before submitting a pull request.

## Code Style

- We use ESLint for JavaScript code linting
- Follow the existing code style
- Use meaningful variable and function names
- Write comments for complex logic
- Keep functions small and focused
- Use async/await for asynchronous operations

Run the linter:
\`\`\`bash
npm run lint
\`\`\`

Fix linting issues:
\`\`\`bash
npm run lint:fix
\`\`\`

## Documentation

- Update README.md with any new requirements or changes
- Comment your code where necessary
- Update API documentation if you change any endpoints
- Include JSDoc comments for functions

## Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## Pull Request Process

1. Update the README.md with details of changes to the interface
2. Update the version numbers in package.json and any other relevant files
3. The PR will be merged once you have the sign-off of at least one maintainer

## License
By contributing, you agree that your contributions will be licensed under its MIT License.

## References
This document was adapted from the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md).