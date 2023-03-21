# Identity Providers
---

In IAM, you can use external Identity Providers instead of creating IAM users and managing their credentials.
IdPs examples are Facebook, Google, Amazon, Azure AD, etc.

## How it works
---
In IAM, you create a _Identity provider_ entity. This can be one of two kinds: OpenID Connect or SAML. We'll focus on the first.

When you configure an Identity provider, you provide 2 configurations for it:
* The Provider URL
* The audience/Application ID. This is given to you when you register your application with the Identity provider.

You can add more than one Application ID to your Identity provider.

Then, you create a IAM role which you configure with the required permissions to access whatever
AWS resources you want the federated users to access, and you configure the Trust policy
of this role so that it is assumable by the federated users of this application.

Technically what this means is that when the user logs in to the application, he is redirected
to the Identity provider to log in. The client application than retreives a Token ID for the user,
and passes this to the STS endpoint of AWS. The Token ID contains 2 important claims: the `aud` (audience) 
which is the application ID, and the `iss` - which is the identity provider's URL. 

The `aud` and `iss` must match the one you configured in the Identity provider in AWS IAM.

Then, STS provides a temporary set of credentials (Access Key ID, Secret Access Key, and Session Token) to the client application,
with which it can access AWS resources.
