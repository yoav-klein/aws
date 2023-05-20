
import json
from urllib.parse import urlencode, urlunparse, urlparse

import requests
import jwt
import boto3
from flask import Flask, render_template, request, session, redirect, url_for
from flask import Flask, url_for, redirect, session
import app_config

app = Flask(__name__)
app.config.from_object(app_config)
app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'

# op = OpenID Provider
op_config = {}

def configure_op():
    url = f"{app_config.AUTHORITY}/.well-known/openid-configuration"
    global op_config
    op_config = requests.get(url).json()


def construct_auth_endpoint_url():    
    query = {
        'scope': 'openid profile offline_access',
        'client_id': app_config.CLIENT_ID,
        'response_type': 'code',
        'response_mode': 'query',
        'state': 'random_string',
        'redirect_uri': app_config.REDIRECT_URI
    }

    query_string = urlencode(query)
    parsed = urlparse(op_config['authorization_endpoint'])
    auth_uri = urlunparse([parsed[0], parsed[1], parsed[2], '', query_string, ''])

    return auth_uri

@app.route("/")
def index():
    if "user" not in session:
        return redirect(url_for("login"))
    
    id_token = session['id_token']

    aws_account_id = app_config.AWS_ACCOUNT_ID
    role_name = app_config.AWS_ROLE_NAME
    aws_uri = f"https://sts.amazonaws.com/?DurationSeconds=900&Action=AssumeRoleWithWebIdentity&Version=2011-06-15&RoleSessionName=web-identity-federation&RoleArn=arn:aws:iam::{aws_account_id}:role/{role_name}&WebIdentityToken={id_token}"

    headers = {'Accept': 'application/json'}
    resp = requests.get(aws_uri, headers=headers)
    
    try:
        resp.raise_for_status()
    except:
        print(resp.text)
        raise

    credentials = resp.json()['AssumeRoleWithWebIdentityResponse']['AssumeRoleWithWebIdentityResult']['Credentials']
    
    s3_client = boto3.client('s3', aws_access_key_id=credentials['AccessKeyId'], aws_secret_access_key=credentials['SecretAccessKey'], aws_session_token=credentials['SessionToken'])
    session['credentials'] = credentials
    buckets = s3_client.list_buckets()['Buckets']

    #return "Done"
    return render_template("index.html", name=session["user"]["name"], buckets=buckets)

@app.route("/login")
def login():
    return render_template("login.html", auth_url=construct_auth_endpoint_url())
    
@app.route("/logout")
def logout():
    session.clear()  # Wipe out user and its token cache from session
    return redirect(  # Also logout from your tenant's web session
        op_config['end_session_endpoint']  + "?post_logout_redirect_uri=" + url_for("index", _external=True))


@app.route(app_config.REDIRECT_PATH)
def authorized():
    print(f"DEBUG:: in authorized:: request recevied: {request}")
    code = request.args['code']
    state = request.args['state']

    token_endpoint = op_config['token_endpoint']
    
    query = {
        'client_id': app_config.CLIENT_ID,
        'code': code,
        'grant_type': 'authorization_code',
        'client_secret': app_config.CLIENT_SECRET,
        'redirect_uri': app_config.REDIRECT_URI
    }

    query_string = urlencode(query)
    
    resp = requests.post(token_endpoint, data=query_string).json()
    
    print(f"DEBUG:: in authorized, after POST to token endpoint, received: {resp}")
    session['user'] = jwt.decode(resp['id_token'], options={"verify_signature": False})
    session['id_token'] = resp['id_token']
    session['access_token'] = resp['access_token']
    
    return redirect(url_for("index"))

def main():
    configure_op()
    app.run()

if __name__ == "__main__":
    main()