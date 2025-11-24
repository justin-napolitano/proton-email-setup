---
slug: github-proton-email-setup-writing-overview
id: github-proton-email-setup-writing-overview
title: Automate Your ProtonMail Setup with proton-email-setup
repo: justin-napolitano/proton-email-setup
githubUrl: https://github.com/justin-napolitano/proton-email-setup
generatedAt: '2025-11-24T17:50:41.892Z'
source: github-auto
summary: >-
  If you’ve ever tried setting up ProtonMail with custom domains, you know it
  can be a hassle. DNS records can be tricky. That's why I created
  **proton-email-setup**. This repository offers a simple shell script to
  automate the configuration of DNS records for ProtonMail using the Cloudflare
  API. Let me walk you through what it does, why I built it, and how it all
  comes together.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: writing
entryLayout: writing
showInProjects: false
showInNotes: false
showInWriting: true
showInLogs: false
---

If you’ve ever tried setting up ProtonMail with custom domains, you know it can be a hassle. DNS records can be tricky. That's why I created **proton-email-setup**. This repository offers a simple shell script to automate the configuration of DNS records for ProtonMail using the Cloudflare API. Let me walk you through what it does, why I built it, and how it all comes together.

## What Is proton-email-setup?

In short, this repo provides a streamlined way to handle ProtonMail DNS requirements programmatically. It eliminates the manual setup, which can be tedious and fraught with errors. With my script, you can configure all the essential DNS records like SPF, DKIM, and DMARC in a snap. Less time tinkering, more time focusing on what actually matters — your emails.

## Why Does It Exist?

I’ve had my fair share of headaches managing DNS records, especially for email services. ProtonMail has some specific needs that, when not met, can lead to deliverability issues. That's why I decided to create a solution that automates this setup process. I wanted to save myself and others the time and frustration of having to do it manually. 

## Key Design Decisions

The design is straightforward but effective. Here’s how I approached it:

- **Shell Script (Bash):** I chose Bash for its simplicity and wide availability across environments. Most developers already have a shell they can run scripts in.
- **Cloudflare API Integration:** Since Cloudflare is a popular choice for DNS management, it made sense to leverage their API. This allows for clean and efficient management of DNS records in one place.
- **Environment Variables:** Instead of hardcoding sensitive information, I use environment variables. This keeps your configurations secure, reducing the risk of exposing API keys or sensitive data.

## Tech Stack

Here’s a look at the tools and technologies that power this project:

- **Bash**: For scripting the automation.
- **Cloudflare DNS API**: To manipulate DNS records.
- **curl**: Handles the HTTP requests to the API.
- **jq**: Parses JSON responses, making data manipulation a breeze.

## Getting Started

If you're itching to try out my script, here's what you need:

### Prerequisites

- A Bash shell environment.
- `curl` and `jq` installed.
- A Cloudflare account with an API token.
- A domain managed by Cloudflare.

### Installation

Getting started is easy. Just clone the repository and navigate to the folder:

```bash
git clone https://github.com/justin-napolitano/proton-email-setup.git
cd proton-email-setup
```

### Configuration

You’ll need to create an `.env` file in the repository root. It should look something like this:

```bash
CF_API_TOKEN=your_cloudflare_api_token
DOMAIN=your_domain.com
PROTON_SPF=proton_spf_value
PROTON_VERIFY=proton_verify_value
PROTON_DKIM1_HOST=dkim1_host_value
PROTON_DKIM1_VALUE=dkim1_value
PROTON_DKIM2_HOST=dkim2_host_value
PROTON_DKIM2_VALUE=dkim2_value
PROTON_DKIM3_HOST=dkim3_host_value
PROTON_DKIM3_VALUE=dkim3_value
PROTON_DMARC=dmarc_value
```

Just replace the placeholders with your actual values, and you’re good to go.

### Usage

To run the setup script, simply execute:

```bash
./setup_proton_dns.sh
```

This script will perform a few key tasks:

- Verify that all environment variables are set correctly.
- Retrieve your Cloudflare Zone ID.
- Manage the DNS records for your ProtonMail setup.

## Project Structure

Here’s how the repo is organized:

```
proton-email-setup/
├── setup_proton_dns.sh  # The main script to configure ProtonMail DNS records
└── .env                 # Holds environment variables (not committed for security)
```

## Future Work / Roadmap

While I’m happy with the current state of the script, there’s always room for improvement. Here’s what I’d like to tackle next:

- **Support for More DNS Providers**: It would be great to extend functionality beyond Cloudflare. A lot of users are on different providers, so this could broaden the appeal.
- **Better Error Handling**: As of now, error handling is pretty basic. I want to add more granular logging and error messages to help users debug issues.
- **Interactive Prompts**: I’m considering adding interactive prompts for missing environment variables. It could make onboarding smoother.
- **Automatic Renewal**: Implementing a feature to renew or update DNS records automatically would be a great time-saver.
- **Containerization**: To simplify deployment, I might containerize the script. This could help with dependency management, too.
- **Testing**: Adding unit and integration tests is on my list to ensure everything runs smoothly with future updates.

## Stay Updated

I love sharing updates about my projects, including any improvements or new features I roll out. You can catch these updates on Mastodon, Bluesky, or Twitter/X. Let’s stay connected!

That's a wrap on my ProtonMail setup automation project. I hope you find it as useful as I intended it to be. Happy emailing!
