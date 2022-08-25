*** Settings ***
Documentation       Ada chatbot laptop ordering IT support digital worker example.

Library    RPA.Robocorp.WorkItems
Library    RPA.Cloud.Google
Library    DateTime
Library    OperatingSystem
Library    RPA.Robocorp.Vault
Library    RPA.Notifier
Suite Setup     Init Sheets    service_account.json

*** Variables ***
${SHEET_RANGE}    Sheet1!A2:D

*** Tasks ***
Order Laptop
    ${payload}=  Get Work Item Payload

    ${values}=    Evaluate    [["${payload}[id]", "${payload}[email]", "${payload}[model]", "${payload}[migrate]"]]

    ${google}=    Get Secret    Google

    Insert Sheet Values
    ...    ${google}[laptop_sheet]
    ...    ${SHEET_RANGE}
    ...    ${values}
    ...    ROWS

    ${mailchimp}=    Get Secret    Mailchimp
    Notify Email
        ...   message=Hi!\n\nYour laptop order for ${payload}[model] has been processed, and you'll receive updates over email for the delivery and migration.\n\nHappy waiting!
        ...   to=${payload}[email]
        ...   username=test@robocorp.com
        ...   password=${mailchimp}[apikey]
        ...   host=smtp.mandrillapp.com
        ...   port=587
        ...   subject=Your laptop order: ${payload}[id]
        ...   from=laptop-orders@robocorp.com

    Release Input Work Item  DONE
