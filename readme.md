# Image Sharing Platform

## Installation

Image Sharing Platform uses remote backend based on S3 + DynamoDB. 
S3 - defined in main.tf and should match S3 defined in https://github.com/kozraf/TFstate_secure
Use jenkins pipeline from https://github.com/kozraf/TFstate_secure to deploy it then use jenkins pipeline located in this project 
to deploy ImageSharingPlatform 