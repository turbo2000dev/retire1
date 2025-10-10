**Project Name:** The Invoicing App

I want to build an app for personal retirement planning.

# Project Overview

## Objective

The app is an retirement planning application individuals, based in the province of Quebec. It provides an easy-to-use solution to plan retirement and consider various scenarios.

## Features

The application has the following features.

### Login & Accounts & Settings

- Ability to register and login using username/password or using social sign-in.
- For each accounts, there is a set of application settings (e.g., dark mode, language, ...).

### Projects

- For each login account, there is the ability to create multiple projects. A project is the planning for a given individual, couple or family.
- For each project, there is a set of basic parameters (one possible value for each parameter; the value is used across the project, regardless of the scenario or event). Examples of the of basic parameters include the name all the indivisuals, their birthdate, ...

### Assets
- For each of the project, there is a set a configurable assets (house, condo, ...) with assoicated parameters, for which there can be variations (i.e., by scenarios).
- The possible assets are:
  - Real Estate (type (house, condo, ...), value, boolean "set at start?")
  - RRSP Account (which individual, value)
  - CELI Account (which individual, value)
  - Cash Account (which individual, value)

### Events

- For each of the project, there is a set a configurable events, e.g., retirement, house sale, ... with assoicated parameters, for which there can be variations (i.e., by scenarios).
- The possible event types and associated parameters are:
  - Retirement (which individual, when)
  - Death (which individual, when)
  - Real Estate Transaction (when, which asset sold, which asset purchased, account from which required money is taken, account to which account excessive money is deposited)
- The parameter "when" can be:
  - Relative (number of years from start of planning)
  - Absolute (calendar year)
  - Age of a specified individual
- The user can add, update and delete events. Each event, a type and the parameters defined.

### Scenarios

- For each project, there is a a set of configurable scenarios, that include a set of parameters and associated values as well as events parameters that can also vary by scenario.
- There is a base scenario. All other scenarios specifiy variations vis-a-vis the base scenario to one or many of the base scenario parameters or events' parameters.
- The user can add, update and delete scenarios. Each scenario has a name.
- Parameters that vary vis-a-vis the base scenario are highlighted so that it is easy to which parameters have a variation.

### Projection

- The projection allows to see for the cash flows and value of the various assets on a yearly basis.
- The values displayed in the projection are based on the scenario selected.
- It is possible for the user to select to display the values in the projection in current dollars or in constant dollars.

### Navigation

- The main navigation items are:
  - Dashboard
  - Base Parameters
  - Assets & Events
  - Scenarios
  - Projection
- There is also a button/icon to navigate to the settings screen (where it is also possible to log out).

# Architecture Overview

The app is developed using Flutter for the front-end, using Freezed, GoRouter and Riverpod as key elements. Firebase is used for the backend, using authentication, Firestore, storage and hosting as key elements.

# Document Index

  -----------------------------------------------------------------------
  Document Name           Description             Priority
  ----------------------- ----------------------- -----------------------
  Project Summay.md       Overview of the         High
                          project, goals and tech 
                          stack.                  

  Design & Best           Explanation of the app  High
  Practices.md.           structure and           
                          associated best         
                          practices.              

  UI Guidelines.md        Provides instructions   High
                          and design guidelines   
                          to ensure a well tough  
                          out responsive layout.  

  -----------------------------------------------------------------------

# Basic UI

- The application can be configured to be used in French or English.

# Other requirements

## Platforms

- I want the application to run on iOS (15 and above), Android, macOS and on the Web.
- I want the application to run and adapt for phones, tablets and desktop.
- The functionality and design adapts depending on the device used.

## Theming
- The app uses dark mode only
- Theming should be done by setting the `theme` in the `MaterialApp`, rather than hardcoding colors and sizes in the widgets themselves

# Other Documents

Design and coding best practices defined in specs/Design Best Practices.md should be followed.

User interface design and coding best practices defined in specs/UI Guidelines.md should be implemented and followed. 
