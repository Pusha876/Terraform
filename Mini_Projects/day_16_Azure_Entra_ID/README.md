## Day 16 — Azure Entra ID (Azure AD) Mini-Project

This folder demonstrates managing Entra ID objects with Terraform:

- Discover your tenant’s verified domains.
- Create users from a CSV (`users.csv`).
- Create Entra ID groups and add members based on department/job title.
- (Optional) Create an application and service principal.

### Structure
- `provider.tf` — Declares the `azuread` provider (auth via `az login` or ARM_* env vars).
- `main.tf` — Reads domains and CSV, creates users, optional app/SP.
- `group.tf` — Creates groups and membership from created users.
- `users.csv` — Input file with columns: `first_name,last_name,department,job_title`.

### Prerequisites
- Azure CLI authenticated to the correct tenant/subscription (`az login`).
- Permissions in Entra ID to create users, groups, and app registrations (typically Application Administrator or User Administrator).

Authentication
- Use your current Azure CLI context (no env vars required), or set environment variables for a Service Principal:
	- ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID

### How to run
```bash
tf init -reconfigure
tf plan
tf apply --auto-approve
```

Outputs
- `domain_names` — List of tenant domains.
- `username` — Computed UPNs for created users.

### Notes
- Password policy: user passwords are generated to meet complexity. You can force change at next sign-in.
- Group membership in `group.tf` filters on `department` and `job_title` from the CSV.
- If names collide, the `for_each` key will conflict; consider adding a numeric suffix in CSV or key derivation.

### Cleanup
```bash
tf destroy --auto-approve
```

