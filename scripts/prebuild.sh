#!/bin/bash

echo "Injecting google-services.json..."
echo $GOOGLE_SERVICES_JSON | base64 --decode > android/app/google-services.json
echo "google-services.json has been created successfully!"
