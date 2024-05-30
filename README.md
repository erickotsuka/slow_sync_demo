# Amplify setup with email login 

1. `amplify init` with default configs
2. `amplify add auth`
```
Do you want to use the default authentication and security configuration? Manual configuration
Select the authentication/authorization services that you want to use: User Sign-Up, Sign-In, connected with AWS IAM controls (Enables per-user Storage features for images or other content,
 Analytics, and more)
Provide a friendly name for your resource that will be used to label this category in the project: slowsyncdemo21fef8ee21fef8ee
Enter a name for your identity pool. slowsyncdemo21fef8ee_identitypool_21fef8ee
Allow unauthenticated logins? (Provides scoped down permissions that you can control via AWS IAM) No
Do you want to enable 3rd party authentication providers in your identity pool? No
Provide a name for your user pool: slowsyncdemo21fef8ee_userpool_21fef8ee
Warning: you will not be able to edit these selections.
How do you want users to be able to sign in? Email
Do you want to add User Pool Groups? No
Do you want to add an admin queries API? No
Multifactor authentication (MFA) user login options: OFF
Email based user registration/forgot password: Enabled (Requires per-user email entry at registration)
Specify an email verification subject: Your verification code
Specify an email verification message: Your verification code is {####}
Do you want to override the default password policy for this User Pool? No
Warning: you will not be able to edit these selections.
What attributes are required for signing up? Email
Specify the app's refresh token expiration period (in days): 30
Do you want to specify the user attributes this app can read and write? No
Do you want to enable any of the following capabilities?
Do you want to use an OAuth flow? No
? Do you want to configure Lambda Triggers for Cognito? No
```

3. `amplify add api`
```
? Select from one of the below mentioned services: GraphQL
? Here is the GraphQL API that we will create. Select a setting to edit or continue Authorization modes: API key (default, expiration time: 7 days from now)
? Choose the default authorization type for the API Amazon Cognito User Pool
Use a Cognito user pool configured as a part of this project.
? Configure additional auth types? Yes
? Choose the additional authorization types you want to configure for the API API key
API key configuration
✔ Enter a description for the API key: ·
✔ After how many days from now the API key should expire (1-365): · 7
? Here is the GraphQL API that we will create. Select a setting to edit or continue Conflict detection (required for DataStore): Disabled
? Enable conflict detection? Yes
? Select the default resolution strategy Auto Merge
? Here is the GraphQL API that we will create. Select a setting to edit or continue Continue
? Choose a schema template: Single object with fields (e.g., “Todo” with ID, name, description)
```

4. Edit the generated `schema.graphql` to rename the model and include owner-based auth rules.

5. `amplify push`

6. `amplify codegen models`

7. In AWS Console, create a Cognito user, marking the email as verified

8. Confirm the user using AWS CLI:
    1. If your AWS CLI credentials are not configured, do so with `aws configure`
    2. Run the following command, replacing the values with the ones from your environment: `aws cognito-idp admin-set-user-password --user-pool-id <YOUR_USER_POOL_ID> --username <COGNITO_USER_NAME (not email)> --password <COGNITO_USER_PASSWORD> --permanent`

9. Create an user in AWS Console using AWS AppSync using API Key auth, passing the Cognito user name (not email) for the `id` field, any value for the `name`, and again the Cognito user name for the `owner`.

10. Run the app in Android Emulator or in an Android device in debug mode.

11. Enter the credentials for the user created in Cognito.

12. Observe what is printed in the console.

The login was tested 3 times for the same user. After each login, the app and the debugging session were closed, and the app's storage was cleared on Android Emulator. These were the results for the elapsed time for the query:

1. 2342 ms
2. 2322 ms
3. 2157 ms

## File amplifyconfiguration.dart omitting sensitive information
```dart
const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "slowsyncdemo": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://*****.appsync-api.us-east-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "*****"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-2:*****",
                            "Region": "us-east-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_*****",
                        "AppClientId": "*****",
                        "Region": "us-east-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://*****.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "slowsyncdemo_AMAZON_COGNITO_USER_POOLS"
                    },
                    "slowsyncdemo_API_KEY": {
                        "ApiUrl": "https://*****.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "*****",
                        "ClientDatabasePrefix": "slowsyncdemo_API_KEY"
                    }
                }
            }
        }
    }
}''';
```

