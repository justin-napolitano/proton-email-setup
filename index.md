---
slug: github-proton-email-setup
title: Automating ProtonMail DNS Setup Using Cloudflare API with Bash Script
repo: justin-napolitano/proton-email-setup
githubUrl: https://github.com/justin-napolitano/proton-email-setup
generatedAt: '2025-11-23T09:27:22.992826Z'
source: github-auto
summary: >-
  A Bash script automates ProtonMail DNS record configuration on Cloudflare domains by managing SPF,
  DKIM, DMARC, and verification records via API.
tags:
  - protonmail
  - cloudflare
  - dns-automation
  - bash
  - shell-scripting
seoPrimaryKeyword: protonmail dns automation
seoSecondaryKeywords:
  - cloudflare api
  - bash script
  - dns configuration
  - email dns setup
seoOptimized: true
topicFamily: automation
topicFamilyConfidence: 1
topicFamilyNotes: >-
  The post is about automating DNS record setup for ProtonMail using a Bash script and Cloudflare
  API, which matches automation family focused on scripting and automation of workflows well.
---

# proton-email-setup: Automating ProtonMail DNS Configuration with Cloudflare API

## Motivation

Configuring DNS records for ProtonMail is a necessary but error-prone and repetitive task, especially when managing multiple domains or accounts. Manual setup involves adding several DNS records including SPF, DKIM, and DMARC entries, which can be tedious and susceptible to human error. This project aims to automate the process by programmatically managing DNS records through the Cloudflare API, reducing manual effort and ensuring consistency.

## Problem

The core problem addressed is the complexity and manual overhead of configuring DNS records for ProtonMail on domains managed by Cloudflare. Users must:

- Retrieve the correct Cloudflare Zone ID for their domain.
- Add or update multiple DNS records with precise values.
- Handle potential conflicts or existing records.
- Manage authentication securely via API tokens.

Without automation, these steps are time-consuming and error-prone.

## How It's Built

The project consists of a single Bash script (`setup_proton_dns.sh`) that:

1. **Loads Configuration:**
   - Reads environment variables from a `.env` file.
   - Requires variables such as `CF_API_TOKEN`, `DOMAIN`, and ProtonMail-specific DNS record values.

2. **Validates Environment:**
   - Checks for presence of required variables.
   - Exits with error messages if configuration is incomplete.

3. **Retrieves Cloudflare Zone ID:**
   - Uses `curl` to query Cloudflare's API for the active zone matching the domain.
   - Parses JSON response with `jq` to extract the zone ID.

4. **Manages DNS Records:**
   - Defines helper functions to delete existing DNS records by type and name.
   - Intended to add or update DNS records for SPF, DKIM (three keys), DMARC, and verification TXT records.

5. **Error Handling:**
   - Uses `set -euo pipefail` for strict error checking.
   - Provides clear error messages for missing tokens, domain, or API failures.

## Implementation Details

- The script relies on standard Unix tools (`bash`, `curl`, `jq`), ensuring compatibility and ease of use.
- Environment variables provide flexibility to configure different domains or ProtonMail keys without modifying the script.
- The script uses the Cloudflare API's `/zones` and `/dns_records` endpoints to query and manipulate DNS records.
- Deletion of existing conflicting DNS records is handled before adding new ones to prevent duplication.
- The script expects the user to supply ProtonMail-specific DNS values, reflecting the need for accurate input.

## Practical Considerations

- The script assumes the domain is managed on Cloudflare and that the API token has sufficient permissions.
- The `.env` file is critical for secure storage of sensitive tokens and configuration.
- The script is designed for idempotent operations, allowing safe re-runs.
- Extensibility is limited to Cloudflare; supporting other DNS providers would require additional code.

## Summary

This project provides a practical, minimalistic automation tool for configuring ProtonMail DNS records on Cloudflare-managed domains. It reduces manual setup complexity by leveraging the Cloudflare API and standard shell scripting. While basic, it forms a foundation for more comprehensive DNS management automation in email infrastructure setups.


