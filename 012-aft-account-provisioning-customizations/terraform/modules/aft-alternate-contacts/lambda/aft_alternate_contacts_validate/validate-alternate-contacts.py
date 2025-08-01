'''
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''
import json
import logging
import os
import boto3
import jsonschema

session = boto3.Session()
logger = logging.getLogger()
if 'log_level' in os.environ:
    logger.setLevel(os.environ['log_level'])
    logger.info("Log level set to %s" % logger.getEffectiveLevel())
else:
    logger.setLevel(logging.INFO)

# Adapted from aft_commons - account_provisioning_framework.py
def validate_request(payload):
    logger.info("Function Start - validate_request")
    schema_path = os.path.join(
        os.path.dirname(__file__), "schemas/valid_alternate_contact_schema.json"
    )
    with open(schema_path) as schema_file:
        schema_object = json.load(schema_file)
    logger.info("Schema Loaded:" + json.dumps(schema_object))
    validated = jsonschema.validate(payload, schema_object)
    if validated is None:
        logger.info("Request Validated")
        return True
    else:
        raise Exception("Failure validating request.\n{validated}")


def lambda_handler(event, context):
  try:
      logger.info("AFT Account Alternate Contact - Handler Start")
      logger.debug(json.dumps(event))
      payload = event
      action = event["action"]
      logger.debug("{} - {}".format(action, payload))

      if action == "validate":
          request_validated = validate_request(payload)
          return request_validated
      else:
          raise Exception(
              "Incorrect Command Passed to Lambda Function. Input: {action}. Expected: 'validate'"
          )

  except Exception as e:
      logger.exception("Error on AFT Acount Alternate contact - {}".format(e))
      raise
