
## Background
---
We use Azure AD as the IdP. We create an _App registration_, which represent an application.
Once we register an application, we get an _Application ID_, which recognizes it.

In Azure AD, we have _tenants_, which are basically Active Directory directories.

Then, we configure a _Identity provider_ entity in AWS IAM. This entity represents our external IdP, and it is recognized
by the _Provider URL_. Within an IdP, we have one or more _audiences_, which are the Application IDs that we've registered
with the IdP.

## What it does
---
We'll create an S3 bucket in AWS, and access it using a user in Azure AD.

## Set the stage
---
### In Azure
Create an App registration in Azure AD. This will provide you with the Application ID.
Make sure to correctly set the Redirect URI.

### In AWS

#### Create an S3 bucket
1. Create an S3 bucket, and put some files there.

#### Create an Identity provider
Create the _Identity provider_ in AWS IAM. The 2 parameters you need to give are:
* Provider URL: Take this from the Endpoints of your App registration. This is the base URL of the endpoints, in the form: `https://login.microsoftonline.com/3bfb3df7-6b1e-447a-8dfc-cac205f2e79f/v2.0`
* Audience: This is the Application ID provided Azure AD when you registered the application.

#### Create a role
Now we need to create a IAM role, give it permissions to the S3 bucket, and let the federated users
assume it.

Take a look at the `trust_policy.json`. Let's break it down:
* The `Principal` field says that this IdP can assume the role
* The `Condition` field says that only the specified Application ID can assume the role.
* The `Action` field say that it is assumable using Web Identity, i.e. OIDC.

1. Change the bucket name in the `access_policy.json` file
2. Change the <tenant_id> and <application_id> and <account_id> in the `trust_policy.json`
3. Create the role as such:
```
$ aws iam create-role --assume-role-policy-document file://./trust_policy.json --role-name azureIdPRole 
$ aws iam create-policy --policy-name azureIdpPolicy --policy-document file://./access_policy.json
$ aws iam attach-role-policy --policy-arn arn:aws:iam::<account_id>:policy/azureIdpPolicy --role-name azureIdPRole
```

## Flow
---
This application is a web application, listening on port 5000.

The flow of the application is as such:

1. The user browses to the `/` endpoint. If he's not logged-in (i.e. `user` key in session), redirected to the `/login` endpoint.
2. `/login` endpoint returns a page with a link to the Authorization Endpoint with a set of parameters.
3. After authenticating to the Identity provider, browser is redirected to the `/getAToken` endpoint with an Authorization Code.
4. Authorization code is used by the application to retrieve an ID token from the Token Endpoint.
5. Browser is redirected back to `/`
6. The application accesses STS API with the ID token to retreive temporary credentials to AWS
7. The credentials are used to list S3 buckets