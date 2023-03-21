

CLIENT_ID = "44f9493e-8d08-4cab-8d57-dbfbdfb5cec8"

CLIENT_SECRET = "Cfu8Q~oGEFLHRAAmxpbJOEq~qsovpc2n2CXDXdt9"

AZ_TENANT_ID = "3bfb3df7-6b1e-447a-8dfc-cac205f2e79f"

AUTHORITY = f"https://login.microsoftonline.com/{AZ_TENANT_ID}/v2.0"

REDIRECT_PATH = "/getAToken"  # Used for forming an absolute URL to your redirect URI.
                              # The absolute URL must match the redirect URI you set
                              # in the app's registration in the Azure portal.

REDIRECT_URI = f"http://localhost:5000{REDIRECT_PATH}"

AWS_ACCOUNT_ID = "023812455170"

AWS_ROLE_NAME = "azureIdPRole"

