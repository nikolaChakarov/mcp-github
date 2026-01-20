---
name: soql-quiries
description: Rules for writing SOQL queries and creating Salesforce records with correct API names
---

# Overview

When writing SOQL queries or creating Salesforce object records in this project, you MUST use the correct Object and Field API names as defined in the schema files.

## Rules

1. **Before writing any SOQL query**: Check the `.sfdx/tools/sobjects/` directory for the correct Object and Field API names
   - Standard objects are in: `.sfdx/tools/sobjects/standardObjects/`
   - Custom objects are in: `.sfdx/tools/sobjects/customObjects/`

2. **Before creating any object records**: Reference the appropriate `.cls` file to verify:
   - Correct Object API name
   - Correct Field API names
   - Required fields
   - Field data types

3. **Never assume field names**: Always verify against the schema files, as field names may include namespace prefixes (e.g., `vmatters__ApiLog__c`) or differ from their labels.

## Example Workflow

- To query Account records → Read `.sfdx/tools/sobjects/standardObjects/Account.cls`
- To create a custom object record → Read the corresponding file in `customObjects/` folder
