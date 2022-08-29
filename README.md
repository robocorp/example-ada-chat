# Ada chatbot conversations triggering Digital Workers

This resource introduces a reference architecture for integrating Robocorp digital workers with [Ada](https://www.ada.cx/) chatbot platform to perform various tasks that are not feasible directly with Ada's capabilities. These would include Web/Desktop automations and much more.

The example simulates an internal IT support chatbot that users can use to submit an order for the new laptop. Example is built with simplicity in mind, and does not cover all nuances of a production implementation.

## What you'll learn with this reference architecture

- Using Ada's HTTP request activity to trigger RPA processes.
- Use Robocorp's work data management and work items
- Write data to Google Sheets
- Use `RPA.Notifier` to send emails from robot
- Use of Robocorp Vault to store secrets

## Overview

<img width="1051" alt="Screenshot 2022-08-29 at 15 01 50" src="https://user-images.githubusercontent.com/40179958/187277851-e501104d-126d-46e9-929a-08ef87de818d.png">

Ada chatbot is first configured to have "Answers" that match to our use case. In this case the triggers are sentences like _"I need a new laptop"_, after which comes a dialogue of questions gauging if user is qualified to have a new laptop, and if yes then what type. Once the chat dialogue is completed a execution of Robocorp process is triggered using Control Room API `Start process with single work item`. User's answers are sent to the process as a work item payload. The process writes the order to a Google Sheet (this simulates the business logic), and alerts the user with email that the order has been processed.

## Configuring the robot

The attached robot code needs to be uploaded to the Control Room, with a few configurations done in order to have access to relevant systems.

- Follow the instructions [here](https://robocorp.com/docs/libraries/rpa-framework/rpa-cloud-google) to share a Google Sheet, and add the contents to the `service_account.json` file.
- Add a Vault entry named `Google` where you should have a secret called `laptop_sheet` that needs to have the ID of the sheet. The ID you can find from the URL when you are viewing your sheet. It's the long string with letters and numbers.
- Add a Vaukt entry named `Mailchimp` where you should have a secret called `apikey` for sending the emails. OR replace this with your own preferred email service in the code.

## Configuring Ada chat

The following (long) image shows the entire Ada answer configuration used in this example. Remember to make sure you use the correct Workspace and Process IDs as well as your own API key from Control Room.
