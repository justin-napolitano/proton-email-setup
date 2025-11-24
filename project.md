---
slug: github-proton-email-setup
id: github-proton-email-setup
title: proton-email-setup
repo: justin-napolitano/proton-email-setup
githubUrl: https://github.com/justin-napolitano/proton-email-setup
generatedAt: '2025-11-24T21:36:00.376Z'
source: github-auto
summary: >-
  A shell script to automate the configuration of DNS records for ProtonMail
  email setup using the Cloudflare API. This repository provides a streamlined
  way to manage ProtonMail DNS requirements programmatically.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: project
entryLayout: project
showInProjects: true
showInNotes: false
showInWriting: false
showInLogs: false
---

A shell script to automate the configuration of DNS records for ProtonMail email setup using the Cloudflare API. This repository provides a streamlined way to manage ProtonMail DNS requirements programmatically.

## Features

- Automates DNS record setup for ProtonMail email service.
- Integrates with Cloudflare API to manage DNS records.
- Supports SPF, DKIM, and DMARC record configuration.
- Uses environment variables for secure and flexible configuration.

## Tech Stack

- Shell script (Bash)
- Cloudflare DNS API
- `curl` for HTTP requests
- `jq` for JSON parsing

## Getting Started

### Prerequisites

- Bash shell environment
- `curl` installed
- `jq` installed
- Cloudflare account with API token
- Domain managed by Cloudflare

### Installation

Clone the repository:

```bash
git clone https://github.com/justin-napolitano/proton-email-setup.git
cd proton-email-setup
```

### Configuration

Create an `.env` file in the repository root with the following variables:

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

Replace placeholder values with your actual ProtonMail DNS records and Cloudflare API token.

### Usage

Run the setup script:

```bash
./setup_proton_dns.sh
```

This script will:
- Verify environment variables
- Retrieve your Cloudflare Zone ID
- Manage DNS records for ProtonMail setup

## Project Structure

```
proton-email-setup/
└── setup_proton_dns.sh  # Main script to configure ProtonMail DNS records
└── .env                 # Environment variables (not committed)
```

## Future Work / Roadmap

- Add support for additional DNS providers beyond Cloudflare.
- Implement more granular error handling and logging.
- Add interactive prompts for missing environment variables.
- Support for automatic renewal or update of DNS records.
- Containerize the script for easier deployment.
- Add unit and integration tests.

