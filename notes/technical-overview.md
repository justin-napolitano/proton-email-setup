---
slug: github-proton-email-setup-note-technical-overview
id: github-proton-email-setup-note-technical-overview
title: Proton Email Setup
repo: justin-napolitano/proton-email-setup
githubUrl: https://github.com/justin-napolitano/proton-email-setup
generatedAt: '2025-11-24T18:43:34.426Z'
source: github-auto
summary: >-
  This repo automates DNS configuration for ProtonMail using the Cloudflare API.
  It simplifies managing your DNS records with a shell script.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: note
entryLayout: note
showInProjects: false
showInNotes: true
showInWriting: false
showInLogs: false
---

This repo automates DNS configuration for ProtonMail using the Cloudflare API. It simplifies managing your DNS records with a shell script.

## Key Features
- Automates DNS setup for ProtonMail.
- Integrates with the Cloudflare API.
- Configures SPF, DKIM, and DMARC records.
- Uses an `.env` file for configuration.

## Tech Stack
- Bash script
- Cloudflare DNS API
- `curl` for requests
- `jq` for JSON parsing

## Getting Started

### Prerequisites
- Bash shell
- `curl` and `jq` installed
- Cloudflare account with API token
- Domain on Cloudflare

### Quick Start

Clone the repo and configure your environment:

```bash
git clone https://github.com/justin-napolitano/proton-email-setup.git
cd proton-email-setup
```

Create an `.env` file with your Cloudflare API token and DNS records. Then run the setup script:

```bash
./setup_proton_dns.sh
```

### Gotchas
Make sure your API token has the right permissions. Double-check your `.env` values; they directly affect the setup.
